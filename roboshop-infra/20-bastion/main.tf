resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.sg_bastion]
  subnet_id = local.subnet_id
  tags = merge(
    local.common_tags, var.var_tags,
    {
      Name = "${var.project}-${var.environment}-bastion"
    }
  )
}