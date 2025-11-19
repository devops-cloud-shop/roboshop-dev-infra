module "catalogue" {
  source = "terraform-aws-modules/security-group/aws" #taken from open source

  name        = "${local.common_name_suffix}-catalogue" #naming convention - roboshop-dev-catalogue
  use_name_prefix = false
  description = "Security group for catalogue-service with custom ports open within VPC, egress all traffic"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value #we use ssm parameter store to store secrets and non-secrets. we use to pull the vpc id using data source.
 
}