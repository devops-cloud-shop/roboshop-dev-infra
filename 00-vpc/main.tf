module "vpc" {

    source = "git::https://github.com/devops-cloud-shop/terraform-aws-vpc.git"

    #VPC
    vpc_cidr = var.vpc_cidr 
    project_name = var.project_name
    environment = var.environment
    vpc_tags = var.vpc_tags
    

    #public subnets
    public_subnet_cidrs = var.public_subnet_cidrs

    #private subnets
    private_subnet_cidrs = var.private_subnet_cidrs

    #databases -comes under private subnet- its a architectural naming preference
    database_subnet_cidrs = var.database_subnet_cidrs

    #peering required or not
    is_peering_required = true
    
}


