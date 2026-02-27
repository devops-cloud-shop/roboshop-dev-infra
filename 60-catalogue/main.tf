resource "aws_instance" "catalogue" {
    ami                     = local.ami_id
    instance_type           = "t3.micro"
    vpc_security_group_ids  = [local.catalogue_sg_id]
    subnet_id               = local.private_subnet_id

    tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-catalogue"
    }

  )
}

#configuring the instance
resource "terraform_data" "catalogue" {
  triggers_replace = [aws_instance.catalogue.id]
  
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.catalogue.private_ip
    }

  #terraform copies this file to mongodb server
  provisioner "file" {
    source = "catalogue.sh"
    destination = "/tmp/catalogue.sh"    
  }

  #to execute the file in the remote server,  we parameterised "component" using variable(position variables) 
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/catalogue.sh" ,
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}" 
     ]
    
  }
  
}

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"

  depends_on  = [ terraform_data.catalogue ]
  
}

resource "aws_ami_from_instance" "catalogue" {
  name                = "${local.common_name_suffix}-catalogue-ami"
  source_instance_id  = aws_instance.catalogue.id

  depends_on = [ aws_ec2_instance_state.catalogue ]
  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-catalogue-ami"
    }
  )
  
}

#creating target group
resource "aws_lb_target_group" "catalogue" {
  name     = "${local.common_name_suffix}-catalogue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60 #waiting period before deleting the instance

  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2
  }
}

#creating launch template
resource "aws_launch_template" "catalogue" {
  name = "${local.common_name_suffix}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id

  instance_type = "t3.micro"

  instance_initiated_shutdown_behavior = "terminate"

  vpc_security_group_ids = [local.catalogue_sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
  }

}

#ASG
resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.common_name_suffix}-catalogue"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = false

  vpc_zone_identifier       = local.private_subnet_ids
  target_group_arns = [aws_lb_target_group.catalogue.arn]

  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 #atleast 50% of instances should be up and running
    }
    triggers = ["launch_template"]
  }


  dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${local.common_name_suffix}-catalogue"
      }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  timeouts {
    delete = "15m"
  }
}

#Autoscaling policy
resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${local.common_name_suffix}-catalogue"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

#create a listener rule
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"]
    }
  }
}

#delete the old instance using aws cli command
resource "terraform_data" "catalogue_local" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  
  depends_on = [aws_autoscaling_policy.catalogue]
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
}