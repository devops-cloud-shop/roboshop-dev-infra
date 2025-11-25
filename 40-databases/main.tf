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

