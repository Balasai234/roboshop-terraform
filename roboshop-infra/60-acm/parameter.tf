resource "aws_ssm_parameter" "acm_certificate" {
  name  = "/${var.project}/${var.environment}/acm/certificate"
  type  = "String"
  value = aws_acm_certificate.roboshop.arn

}