locals {
   ami_id = data.aws_ami.joindevops.id
  sg_mongodb = data.aws_ssm_parameter.mongodb_sg_id.value
  subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
}