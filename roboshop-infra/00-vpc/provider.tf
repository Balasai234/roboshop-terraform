provider "aws" {
    
  region="us-east-1"
}
terraform {
  
  backend "s3" {
    bucket = "remote-state-demo-cheni"
    key    = "roboshop-infra/00-vpc/terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}