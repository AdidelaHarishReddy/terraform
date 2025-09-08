resource "aws_vpc" "project_vpc" {
#   count = local.create_vpc ? 1 : 0

#   cidr_block          = var.use_ipam_pool ? null : var.cidr
  cidr_block                           = var.cidr_block
#   ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
#   ipv4_netmask_length                  = var.ipv4_netmask_length
  instance_tenancy                     = var.instance_tenancy
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  tags = {
       Name = var.vpc_name 
       }
}