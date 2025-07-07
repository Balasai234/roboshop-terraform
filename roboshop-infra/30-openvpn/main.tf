resource "aws_instance" "openvpn" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id = local.subnet_id
    user_data = file("openvpn.sh")
    key_name = "VPC"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-openvpn"
    }
  )
}
resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
}