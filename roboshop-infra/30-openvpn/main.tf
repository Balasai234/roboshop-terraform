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
resource "aws_route53_record" "vpn" {
  zone_id = var.zone_id
  name    = "vpn-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.openvpn.public_ip]
  allow_overwrite = true
}