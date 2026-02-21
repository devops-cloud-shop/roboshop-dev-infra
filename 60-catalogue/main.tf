resource "aws_instance" "catalogue" {
    ami           = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    subnet_id = local.private_subnet_id

    tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-catalogue"
    }

  )
}

resource "terraform_data" "catalogue" {
  triggers_replace = [aws_instance.catalogue.id]
  
  connection {
    type = "ssh"
    user = "eec2-user"
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
