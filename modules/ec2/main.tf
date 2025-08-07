variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "tags" {}

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  tags          = var.tags
}

