resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.environment}/vpc/id"
  type  = "String"
  value = module.vpc.vpc_id
}
resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project}/${var.environment}/vpc/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}
resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project}/${var.environment}/vpc/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}
resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project}/${var.environment}/vpc/database_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.database_subnet_ids)
}