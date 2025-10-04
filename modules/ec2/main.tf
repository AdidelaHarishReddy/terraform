resource "aws_instance" "this" {
  subnet_id     = var.subnet_ids[count.index]
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  count         = var.node_count
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    delete_on_termination = true
  }
  tags          = var.tags
}

