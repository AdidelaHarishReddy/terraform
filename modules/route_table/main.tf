resource "aws_route_table" "public" {
    vpc_id = var.vpc_id

    route {
        cidr_block = var.subnet_cidr
        gateway_id = var.igw_id
    }

    tags = var.routetable_name
}