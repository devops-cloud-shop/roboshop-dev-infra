/* # resource "aws_security_group_rule" "frontend_frontend_alb" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   security_group_id = module.sg[9].sg_id #frontend SG ID
#   source_security_group_id = module.sg[11].sg_id #Frontend ALB SG ID
# } */


#Backend ALB accepting traffic from Bastion 
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = local.backend_alb_sg_id #backend-alb SG ID
  source_security_group_id = local.bastion_sg_id #Bastion SG ID
}

resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.bastion_sg_id #bastion SG ID
}

#mongodb accepting traffic from bastion
resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id 
  source_security_group_id = local.bastion_sg_id #bastion SG ID
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  
}

#redis allow connection from bastion
resource "aws_security_group_rule" "redis_bastion" {
  type              = "ingress"
  security_group_id = local.redis_sg_id 
  source_security_group_id = local.bastion_sg_id #bastion SG ID
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  
}

#rabbitmq allow connection from bastion
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  security_group_id = local.rabbitmq_sg_id 
  source_security_group_id = local.bastion_sg_id #bastion SG ID
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  
}

