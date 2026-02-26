/* # resource "aws_security_group_rule" "frontend_frontend_alb" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   security_group_id = module.sg[9].sg_id #frontend SG ID
#   source_security_group_id = module.sg[11].sg_id #Frontend ALB SG ID
# } */

resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.bastion_sg_id #bastion SG ID
}

#Backend ALB accepting traffic from Bastion 
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = local.backend_alb_sg_id #backend-alb SG ID
  source_security_group_id = local.bastion_sg_id #Bastion SG ID
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

#mongodb allowing connection from catalogue
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id 
  source_security_group_id = local.catalogue_sg_id #catalogue SG ID
  from_port         = 27017
  to_port           = 27017
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

#mysql allowing traffic from bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id 
  source_security_group_id = local.bastion_sg_id #bastion SG ID
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  
}

#catalogue accepting traffic from bastion -port 22
resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  security_group_id = local.catalogue_sg_id 
  source_security_group_id = local.bastion_sg_id #bastion SG ID
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type                      = "ingress"
  security_group_id         = local.catalogue_sg_id
  source_security_group_id  = local.backend_alb_sg_id
  from_port                 = 8080
  protocol                  = "tcp"
  to_port                   = 8080
}

#frontend_alb rules to allow public internet
resource "aws_security_group_rule" "frontend_alb_public" {
  type              = "ingress"
  security_group_id = local.frontend_alb_sg_id
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
}



