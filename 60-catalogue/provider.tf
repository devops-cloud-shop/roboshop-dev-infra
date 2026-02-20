terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "6.16.0"
    }
  }

  backend "s3" {
    bucket          = "remote-state-infra-dev"
    key             = "roboshop-dev-backend"
    region          = "us-east-1"
    use_lockfile    = true
    encrypt         = true
  }
}

#provider configuration
provider "aws" {
    region = "us-east-1"
}