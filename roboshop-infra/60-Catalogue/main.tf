resource "aws_lb_target_group" "catalogue_tg" {
  name     = "${var.project}-${var.environment}-catalogue-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/health"
    interval            = 5
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher = "200-299"
    port=8080
  }

  tags = merge(
    local.common_tags,
    {
      Name        = "${var.project}-${var.environment}-catalogue-tg"
      Environment = var.environment
      Project     = var.project
    }
  )
  
}
resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id     = local.private_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name        = "${var.project}-${var.environment}-catalogue"
      Environment = var.environment
      Project     = var.project
    }
  )
}
