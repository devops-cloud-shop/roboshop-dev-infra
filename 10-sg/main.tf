################# Using OPEN SOURCE MODULE ############
/* module "catalogue" {
  source = "terraform-aws-modules/security-group/aws" #taken from open source

  name        = "${local.common_name_suffix}-catalogue" #naming convention - roboshop-dev-catalogue
  use_name_prefix = false
  description = "Security group for catalogue-service with custom ports open within VPC, egress all traffic"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value #we use ssm parameter store to store secrets and non-secrets. we use to pull the vpc id using data source.
 
} */

########## CUSTOM MODULE ###########

module "sg" {
  count = length(var.sg_names)
  source = "git::https://github.com/devops-cloud-shop/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_name =  var.sg_names[count.index]
  sg_description = "Security group created for ${var.sg_names[count.index]}"
  vpc_id = local.vpc_id
}