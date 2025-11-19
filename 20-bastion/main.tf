resource "aws_instance" "bastion" {
  ami                     = local.ami_id #mandatory
  instance_type           = "t3.micro" #mandatory
  vpc_security_group_ids  = [local.bastion_sg_id] #mandatory
  tags                    = merge (
        local.common_tags,
        {
        Name = "${var.project_name}-${var.environment}-bastion"
        }
    )
}