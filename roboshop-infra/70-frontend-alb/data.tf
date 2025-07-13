data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/vpc/public_subnet_ids"


  
}
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc/id"
  
}
data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/frontend_alb_sg_id"
  
}
data "aws_ssm_parameter" "acm_certificate" {
  name = "/${var.project}/${var.environment}/acm/certificate"

}