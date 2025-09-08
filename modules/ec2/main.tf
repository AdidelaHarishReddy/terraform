resource "aws_instance" "this" {
  subnet_id     = var.subnet_ids[count.index]
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  count         = var.node_count
  vpc_security_group_ids = var.security_group_ids
  tags          = var.tags
}

