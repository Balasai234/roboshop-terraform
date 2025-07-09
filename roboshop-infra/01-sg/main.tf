module "sg_frontend" {
  source = "../../Terraform/aws-SGM"
  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id = local.vpc_id
  project = var.project
 environment = var.environment
  
}

module "sg_bastion" {
  source = "../../Terraform/aws-SGM"
  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id = local.vpc_id
  project = var.project
 environment = var.environment
  
}
module "backend_alb" {
  source = "../../Terraform/aws-SGM"
  sg_name = "backend_alb"
  sg_description = "Security group for backend ALB"
  vpc_id = local.vpc_id
  project = var.project
  environment = var.environment
}
module "vpn" {
  source = "../../Terraform/aws-SGM"
  sg_name = "vpn"
  sg_description = "Security group for OpenVPN server"
  vpc_id = local.vpc_id
  project = var.project
  environment = var.environment
  
}
module "MongoDB" {
  source = "../../Terraform/aws-SGM"
  sg_name = "mongodb"
  sg_description = "Security group for MongoDB"
  vpc_id = local.vpc_id
  project = var.project
  environment = var.environment
  
}
module "redis" {
  source = "../../Terraform/aws-SGM"
  sg_name = "redis"
  sg_description = "Security group for Redis"
  vpc_id = local.vpc_id
  project = var.project
  environment = var.environment
  
}
module "MySQL" {
  source = "../../Terraform/aws-SGM"
  sg_name = "mysql"
  sg_description = "Security group for MySQL"
  vpc_id = local.vpc_id
  project = var.project
  environment = var.environment
  
}
module "RabbitMQ" {
  source = "../../Terraform/aws-SGM"
  sg_name = "rabbitmq"
  sg_description = "Security group for RabbitMQ"
  vpc_id = local.vpc_id
  project = var.project
  environment = var.environment
  
}
module "catalogue" {
  source = "../../Terraform/aws-SGM"
  sg_name = "catalogue"
  sg_description = "Security group for Catalogue service"
  vpc_id = local.vpc_id
  project = var.project
  environment = var.environment
  
}
#bastion accespting connections from laptop
resource "aws_security_group" "bastion_laptop" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }
}
# backend ALB accepting connections from my bastion host on port no 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.sg_bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}
#VPN ports 22, 443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
# MongoDB accepting connections from VPN on port 27017 and SSH on port 22
resource "aws_security_group_rule" "mongodb_vpn" {
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.MongoDB.sg_id 
}
# Redis
resource "aws_security_group_rule" "redis_vpn" {
  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index]
  to_port           = var.redis_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.redis.sg_id
}
# MySQL accepting connections from VPN on port 3306 and SSH on port 22
resource "aws_security_group_rule" "mysql_vpn" {
  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index]
  to_port           = var.mysql_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.MySQL.sg_id 
}
# RabbitMQ accepting connections from VPN on port 5672 and SSH on port 22
resource "aws_security_group_rule" "rabbitmq_vpn" {
  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index]
  to_port           = var.rabbitmq_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.RabbitMQ.sg_id 
}
# Allowing the Bastion host to access the VPN on port 22
resource "aws_security_group_rule" "catalogue_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}
# Allowing the Bastion host to access the Catalogue service on port 22
resource "aws_security_group_rule" "catalogue_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.catalogue.sg_id
}
# Allowing the VPN to access the Catalogue service on port 8080
resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}
# Allowing the backend ALB to access the Catalogue service on port 8080
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.catalogue.sg_id
}