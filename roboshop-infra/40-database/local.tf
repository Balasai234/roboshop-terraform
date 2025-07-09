locals {
   ami_id = data.aws_ami.joindevops.id
  sg_mongodb = data.aws_ssm_parameter.mongodb_sg_id.value
  subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
  sg_redis = data.aws_ssm_parameter.redis_sg_id.value
  sg_mysql = data.aws_ssm_parameter.mysql_sg_id.value
  sg_rabbitmq = data.aws_ssm_parameter.rabbitmq_sg_id.value
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
}