variable "ingress_rules" {
  description = "List of ingress rules for the NACL"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_block       = string
    # ipv6_cidr_block  = string
    rule_no          = number
    action           = string
  }))
  default = [
    {
      description      = "Allow HTTP traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      rule_no          = 100
      action           = "allow"
    },
    {
      description      = "Allow SSH traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      rule_no          = 200
      action           = "allow"
    },
    {
      description      = "Allow HTTPS traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 99
    },
    {
      description      = "Allow BGP(used by calico) traffic"
      from_port        = 179
      to_port          = 179
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 100
    },
    { description      = "Allow coredns traffic"
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 101
    },
    {
      description      = "Allow all main traffic"
      from_port        = 1024
      to_port          = 65535
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 102
    },
    {
      description      = "Allow icmp traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "icmp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 103
    }

  ]
}

variable "egress_rules" {
  description = "List of egress rules for the NACL"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_block      = string
    # ipv6_cidr_block = string
    rule_no         = number
    action          = string
  }))
  default = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1" # -1 means all protocols
      cidr_block      = "0.0.0.0/0"
      # ipv6_cidr_block = "::/0"
      rule_no         = 100
      action          = "allow"
    }
  ]
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "nacl_name" {
  description = "Name of the NACL"
  type        = string
}