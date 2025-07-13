provider "aws" {
    
  region="us-east-1"
}
terraform {
   required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0"
    }
  }
  
  backend "s3" {
    bucket = "remote-state-demo-cheni"
    key    = "70-frontend-alb/terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}