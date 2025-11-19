################# Using OPEN SOURCE MODULE ############
/* module "catalogue" {
  source = "terraform-aws-modules/security-group/aws" #taken from open source

  name        = "${local.common_name_suffix}-catalogue" #naming convention - roboshop-dev-catalogue
  use_name_prefix = false
  description = "Security group for catalogue-service with custom ports open within VPC, egress all traffic"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value #we use ssm parameter store to store secrets and non-secrets. we use to pull the vpc id using data source.
 
} */


module "sg" {
  source = "git::https://github.com/devops-cloud-shop/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_name =  "mongodb"
  sg_description = "Security group for mongodb service"
  vpc_id = local.vpc_id
}