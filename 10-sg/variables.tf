variable "project_name" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "sg_names" {
    default = [
        #database
        "mongodb", "redis", "mysql", "rabbitmq",
        #backend
        "catalogue", "cart", "user", "payment", "shipping",
        #frontend
        "frontend",
        #bastion
        "bastion",
        #frontend Load balancer
        "frontend_alb",
        #backend Load balancer
        "backend_alb"

    ]
  
}