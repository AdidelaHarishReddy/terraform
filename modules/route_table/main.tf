resource "aws_route_table" "public" {
    vpc_id = var.vpc_id

    dynamic "route" {
    for_each = var.igw_id != null ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.igw_id
    }
  }

    tags = var.routetable_name
}