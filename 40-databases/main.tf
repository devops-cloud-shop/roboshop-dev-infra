resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id = local.database_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-mongodb"
    }

  )
}

resource "terraform_data" "mongodb" {
  triggers_replace = [aws_instance.mongodb.id]
  
  connection {
    type = "ssh"
    user = "eec2-user"
    password = "DevOps321"
    host = aws_instance.mongodb.private_ip
    }

  #terraform copies this file to mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"    
  }

  #to execute the file in the remote server,  we parameterised "component" using variable(position variables) 
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh" ,
      "sudo sh /tmp/bootstrap.sh mongodb dev" 
     ]
    
  }
  
}

#redis
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id = local.database_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-redis"
    }

  )
}
resource "terraform_data" "redis" {
  triggers_replace = [aws_instance.redis.id]
  
  connection {
    type = "ssh"
    user = "eec2-user"
    password = "DevOps321"
    host = aws_instance.redis.private_ip
    }

  #terraform copies this file to mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"    
  }

  #to execute the file in the remote server,  we parameterised "component" using variable(position variables) 
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh" ,
      "sudo sh /tmp/bootstrap.sh redis dev" 
     ]
    
  }
}

#rabbitmq
resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id = local.database_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-rabbitmq"
    }

  )
}
resource "terraform_data" "rabbitmq" {
  triggers_replace = [aws_instance.rabbitmq.id]
  
  connection {
    type = "ssh"
    user = "eec2-user"
    password = "DevOps321"
    host = aws_instance.rabbitmq.private_ip
    }

  #terraform copies this file to mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"    
  }

  #to execute the file in the remote server,  we parameterised "component" using variable(position variables) 
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh" ,
      "sudo sh /tmp/bootstrap.sh rabbitmq dev" 
     ]
    
  }
}

#mysql
resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id = local.database_subnet_ids
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-mysql"
    }

  )
}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSMParameterRead"
}

resource "terraform_data" "mysql" {
  triggers_replace = [aws_instance.mysql.id]
  
  connection {
    type = "ssh"
    user = "eec2-user"
    password = "DevOps321"
    host = aws_instance.mysql.private_ip
    }

  #terraform copies this file to mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"    
  }

  #to execute the file in the remote server,  we parameterised "component" using variable(position variables) 
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh" ,
      "sudo sh /tmp/bootstrap.sh mysql dev" 
     ]
    
  }
}

