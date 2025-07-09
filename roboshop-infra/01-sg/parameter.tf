resource "aws_ssm_parameter" "sg_frontend" {
  name = "${var.frontend_sg_name}-${var.project}-${var.environment}"
  type = "String"
  value = module.sg_frontend.sg_id
}
resource "aws_ssm_parameter" "bastion_laptop" {

    name = "/${var.bastion_sg_name}-${var.project}-${var.environment}/bastion_laptop"
  type = "String"
  value = module.sg_bastion.sg_id

}
resource "aws_ssm_parameter" "backend_alb_sg_id" {
  name  = "/${var.project}/${var.environment}/backend_alb_sg_id"
  type  = "String"
  value = module.backend_alb.sg_id
}
resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project}/${var.environment}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
}
resource "aws_ssm_parameter" "mongodb_sg_id" {
  name  = "/${var.project}/${var.environment}/mongodb_sg_id"
  type  = "String"
  value = module.MongoDB.sg_id
}
resource "aws_ssm_parameter" "redis_sg_id" {
  name  = "/${var.project}/${var.environment}/redis_sg_id"
  type  = "String"
  value = module.redis.sg_id
}
resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${var.project}/${var.environment}/mysql_sg_id"
  type  = "String"
  value = module.MySQL.sg_id
}
resource "aws_ssm_parameter" "rabbitmq_sg_id" {
  name  = "/${var.project}/${var.environment}/rabbitmq_sg_id"
  type  = "String"
  value = module.RabbitMQ.sg_id
}
resource "aws_ssm_parameter" "catalogue_sg_id" {
  name  = "/${var.project}/${var.environment}/catalogue_sg_id"
  type  = "String"
  value = module.catalogue.sg_id
}