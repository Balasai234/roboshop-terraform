module "vpc" {
    source = "../../Terraform/VPC-module"
    project = var.project
    environment = var.environment
    public_cidr_block = var.public_subnet_cidrs
    private_cidr_block = var.private_subnet_cidrs
    database_cidr_block = var.database_subnet_cidrs


}