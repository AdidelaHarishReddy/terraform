resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id # Reference to your existing VPC
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = var.subnet_name
  }
}