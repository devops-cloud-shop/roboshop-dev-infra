resource "aws_instance" "bastion" {
  ami                     = local.ami_id #mandatory
  instance_type           = "t3.micro" #mandatory
  vpc_security_group_ids  = [local.bastion_sg_id] #mandatory
  subnet_id               = local.public_subnet_id

  user_data = file("bastion.sh") #file is a funtn which reads bastion.sh and execute the script when bastion server is being started.
  tags                    = merge (
        local.common_tags,
        {
        Name = "${var.project_name}-${var.environment}-bastion"
        }
    )
}