resource "aws_network_acl" "nacl" {
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_block       = ingress.value.cidr_block # Corrected to singular cidr_block
      # ipv6_cidr_block  = ingress.value.ipv6_cidr_block
      rule_no          = ingress.value.rule_no # Required for NACL
      action           = ingress.value.action # Required for NACL (allow/deny)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules # Made dynamic for consistency and flexibility
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_block       = egress.value.cidr_block # Corrected to singular cidr_block
      # ipv6_cidr_block  = egress.value.ipv6_cidr_block
      rule_no          = egress.value.rule_no # Required for NACL
      action           = egress.value.action # Required for NACL
    }
  }

  tags = {
    Name = var.nacl_name
  }
}