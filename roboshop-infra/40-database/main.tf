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