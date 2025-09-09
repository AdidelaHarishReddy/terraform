variable "ingress_rules" {
  description = "List of ingress rules for the NACL"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_block       = string
    ipv6_cidr_block  = string
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
      ipv6_cidr_block  = "::/0"
      rule_no          = 100
      action           = "allow"
    },
    {
      description      = "Allow SSH traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_block       = "192.168.1.0/24"
      ipv6_cidr_block  = "::/0"
      rule_no          = 200
      action           = "allow"
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
    ipv6_cidr_block = string
    rule_no         = number
    action          = string
  }))
  default = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1" # -1 means all protocols
      cidr_block      = "0.0.0.0/0"
      ipv6_cidr_block = "::/0"
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