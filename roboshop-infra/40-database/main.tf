resource "aws_instance" "MongoDB" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.sg_mongodb]
  subnet_id = local.subnet_id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mongodb"
    }
  ) 
  
}


resource "terraform_data" "MongoDB" {
  triggers_replace = [
    aws_instance.MongoDB.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.MongoDB.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
}
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.sg_redis]
  subnet_id = local.subnet_id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-redis"
    }
  ) 
  
}


resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
}
resource "aws_instance" "MySQL" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.sg_mysql]
  subnet_id = local.subnet_id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mysql"
    }
  ) 
  
}
resource "terraform_data" "MySQL" {
  triggers_replace = [
    aws_instance.MySQL.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.MySQL.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}
resource "aws_instance" "RabbitMQ" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.sg_rabbitmq]
  subnet_id = local.subnet_id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-rabbitmq"
    }
  ) 
  
}
resource "terraform_data" "RabbitMQ" {
  triggers_replace = [
    aws_instance.RabbitMQ.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.RabbitMQ.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
}
resource "aws_route53_record" "MongoDB" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.zone_name}" #mongodb-dev.daws84s.site
  type    = "A"
  ttl     = 1
  records = [aws_instance.MongoDB.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "MySQL" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.MySQL.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "RabbitMQ" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.RabbitMQ.private_ip]
  allow_overwrite = true
}