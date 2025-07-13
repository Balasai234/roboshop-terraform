# Target Group for catalogue service
# This target group will be used by the ALB to route traffic to the catalogue service instances
# It will listen on port 8080 and use HTTP protocol
# The health check will be performed on the /health endpoint of the catalogue service
# The health check will be performed every 5 seconds with a timeout of 5 seconds
# The target group will be created in the VPC specified by the vpc_id variable
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
resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}
# This resource will stop the catalogue instance after it is provisioned and configured
# The instance will be stopped to create an AMI from it
resource "aws_ec2_instance_state" "catalogue" {
  state = "stopped"
  instance_id = aws_instance.catalogue.id
  depends_on = [terraform_data.catalogue]
}
# This resource will create an AMI from the catalogue instance
# The AMI will be used to launch instances in the Auto Scaling group
# The AMI will be created after the catalogue instance is provisioned and configured
# The AMI will be tagged with the common tags and the name of the catalogue service
# The AMI will be used in the launch template for the catalogue service
# The AMI will be created in the same region as the catalogue instance
# The AMI will be created from the catalogue instance after it is stopped
# The AMI will be used to launch instances in the Auto Scaling group
resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue]

tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-catalogue"
    }
  )
}
resource "terraform_data" "cataloguedelete" {
  triggers_replace = [
    aws_ami_from_instance.catalogue.id
  ]
  
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }

  depends_on = [aws_ami_from_instance.catalogue]
}
# Launch template for the catalogue service
# This template will be used to launch instances for the catalogue service
# It will use the AMI created from the catalogue instance
resource "aws_launch_template" "catalogue" {
  name_prefix   = "${var.project}-${var.environment}-catalogue"
  image_id      = aws_ami_from_instance.catalogue.id
  instance_type = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = [local.catalogue_sg_id]
  update_default_version = true # each time you update, new version will become default
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name        = "${var.project}-${var.environment}-catalogue"
        Environment = var.environment
        Project     = var.project
      }
    )
  }
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name        = "${var.project}-${var.environment}-catalogue"
        Environment = var.environment
        Project     = var.project
      }
    )
  }
  tag_specifications {
    resource_type = "launch-template"

    tags = merge(
      local.common_tags,
      {
        Name        = "${var.project}-${var.environment}-catalogue"
        Environment = var.environment
        Project     = var.project
      }
    )
  }
}
# Auto Scaling group for the catalogue service
# This group will manage the catalogue instances based on the launch template
# It will ensure that the desired number of instances are running and will replace unhealthy instances  
# It will also register the instances with the catalogue target group
# The instances will be launched in the private subnets of the VPC
# The instances will be tagged with the common tags and the name of the catalogue service
# The instances will be launched using the launch template created above
resource "aws_autoscaling_group" "catalogue" {
  name         = "${var.project}-${var.environment}-catalogue-asg"
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }
  min_size            = 1
  max_size            = 10
  desired_capacity    = 1
  vpc_zone_identifier = [local.private_subnet_ids]
  target_group_arns   = [aws_lb_target_group.catalogue_tg.arn]

  health_check_type          = "ELB"
  health_check_grace_period = 120

dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
    )
    content{
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
    
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      instance_warmup = 60
      min_healthy_percentage = 90
    }
    triggers = ["launch_template"]
  }
  
}
# Auto Scaling policy based on average CPU usage

resource "aws_autoscaling_policy" "catalogue" {
  name                   = "${var.project}-${var.environment}-catalogue"
  scaling_adjustment      = 1
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    target_value       = 75.0
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
  cooldown               = 90
  autoscaling_group_name = aws_autoscaling_group.catalogue.name

}
# Listener rule for routing traffic to the catalogue target group
# This rule will forward requests to the catalogue target group based on the host header
# The host header should match the catalogue service domain name
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn=local.backend_alb_listener_arn
  priority    = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue_tg.arn
  }

  condition {
     host_header {
      values = ["catalogue.backend-${var.environment}.${var.zone_name}"]
    }
  }
}