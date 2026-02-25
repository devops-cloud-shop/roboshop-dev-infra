data "aws_ami" "prav-devops" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project_name}/${var.environment}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project_name}/${var.environment}/redis_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project_name}/${var.environment}/rabbitmq_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/database_subnet_ids"
}