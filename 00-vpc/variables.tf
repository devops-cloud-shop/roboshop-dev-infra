variable "vpc_cidr" {
    type = string
    description = "cidr for roboshop project"
    default = "10.0.0.0/16"
}

variable "project_name" {
    type = string
    default = "roboshop"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "vpc_tags" {
    type = map
    default = {
        Purpose = "Roboshop-dev-VPC"
        DontDelete = true
    }
}

variable "public_subnet_cidrs" {
    type = list
    default = [ "10.0.1.0/24" , "10.0.2.0/24" ]
}


variable "private_subnet_cidrs" {
    type = list
    default = [ "10.0.11.0/24" , "10.0.12.0/24"]
}


variable "database_subnet_cidrs" {
    type = list
    default = [ "10.0.21.0/24", "10.0.22.0/24" ]
}

