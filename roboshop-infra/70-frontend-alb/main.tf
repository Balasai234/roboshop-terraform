module "frontend_alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.16.0"
  name    = "${var.project}-${var.environment}-frontend-alb"
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  # The ALB will be created in the VPC specified by the vpc_id variable
  create_security_group = "false"
  internal = "false"
  security_groups = [local.frontend_alb_sg_id]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-frontend-alb"
    }
  )
}


resource "aws_lb_listener" "frontend_alb_listener" {
  load_balancer_arn = module.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.acm_certificate_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Fixed response content</h1>"
      status_code  = "200"
    }
  }
}
resource "aws_route53_record" "frontend_alb" {
  zone_id = var.zone_id
  name    = "dev.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.frontend_alb.dns_name
    zone_id                = module.frontend_alb.zone_id # This is the ZONE ID of ALB
    evaluate_target_health = true
  }
}