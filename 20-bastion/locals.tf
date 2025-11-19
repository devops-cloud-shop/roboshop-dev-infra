locals {
   ami_id = data.aws_ami.prav-devops.id
   bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value 
   common_tags = {
        Project = var.project_name
        Environment = var.environment
        Terraform = true
   }
}