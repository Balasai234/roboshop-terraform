
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/vpc/public_subnet_ids"
}
data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project}/${var.environment}/vpn_sg_id"
}
data "aws_ami" "openvpn" {
  owners           = ["679593333241"]
  most_recent      = true

  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-8fbe3379-*"]
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