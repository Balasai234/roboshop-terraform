locals {
  ami_id = data.aws_ami.joindevops.id
  sg_bastion = data.aws_ssm_parameter.sg_bastion.value
  subnet_id = split(",", data.aws_ssm_parameter.public_subnet_id_bastion.value)[0]
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }

}
