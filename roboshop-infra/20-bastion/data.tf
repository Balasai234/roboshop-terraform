# File: roboshop-infra/20-bastion/data.tf
data "aws_ssm_parameter" "sg_bastion" {
  name = "/bastion-sg-${var.project}-${var.environment}/bastion_laptop"
}
data "aws_ami" "joindevops" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
}
data "aws_ssm_parameter" "public_subnet_id_bastion" {
  name = "/${var.project}/${var.environment}/vpc/public_subnet_ids"
}