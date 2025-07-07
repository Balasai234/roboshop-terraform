locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  subnets = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
#backend_alb_sg_id is used to reference the security group for the backend ALB
  # This is used to reference the security group for the backend ALB
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
}