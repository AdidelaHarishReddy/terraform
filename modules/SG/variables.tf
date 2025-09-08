variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
  }))
  default = []
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
  default     = ""
}

variable "sg_tags" {
  description = "Tags to apply to the Security Group"
  type        = map(string)
  default = {
    Name        = "sg_80_22_traffic"
    Environment = "default"
  }
} 

