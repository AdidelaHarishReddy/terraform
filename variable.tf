# variable "cluster_name" {
#     description = "The name of the Kubernetes cluster"
#     type        = string
# }

variable "region" {
    description = "The region where the resources will be created"
    type        = string
    default     = "ap-south-1"
}

variable "node_count" {
    description = "Number of nodes in the Kubernetes cluster"
    type        = number
    default     = 1
}

variable "m_node_count" {
    description = "Number of nodes in the Kubernetes cluster"
    type        = number
    default     = 1
}

variable "instance_type" {
    description = "Instance type for the cluster nodes"
    type        = string
    default     = "t3.micro"
}

variable "m_instance_type" {
    description = "Instance type for the cluster nodes"
    type        = string
    default     = "t3.small"
}

variable "vpc_id" {
    description = "The VPC ID where the cluster will be deployed"
    type        = string
    default     = ""
}

variable "subnet_ids" {
    description = "A list of subnet IDs for the cluster"
    type        = list(string)
    default     = []
}

variable "tags" {
    description = "A list of tags to assign to the cluster resources"
    type        = map(string)
    default     = {"Name" = "worker-k8s"}
}

variable "m_tags" {
    description = "A list of tags to assign to the cluster resources"
    type        = map(string)
    default     = {"Name" = "master-k8s"}
}

variable "key_name" {
    description = "The name of the key pair to use for the EC2 instances"
    type        = string
    default     = "mahesh1"
}

variable "cidr_block" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}


variable "vpc_name" {
  type = string
  default = "project_vpc"
}

variable "pub_subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "pvt_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ingress_rules" {
  description = "List of ingress rules for the NACL"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_block       = string
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
      rule_no          = 90
      action           = "allow"
    },
    {
      description      = "Allow SSH traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      rule_no          = 91
      action           = "allow"
    },
    {
      description      = "Allow HTTPS traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 92
    },
    {
      description      = "Allow BGP(used by calico) traffic"
      from_port        = 179
      to_port          = 179
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 93
    },
    { 
      description      = "Allow coredns traffic"
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 94
    },
    {
      description      = "Allow all main traffic"
      from_port        = 1024
      to_port          = 65535
      protocol         = "tcp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 95
    },
    {
      description      = "Allow all main traffic"
      from_port        = 1024
      to_port          = 65535
      protocol         = "udp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 97
    },
    {
      description      = "Allow icmp traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "icmp"
      cidr_block       = "0.0.0.0/0"
      action           = "allow"
      rule_no          = 96
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
    rule_no         = number
    action          = string
  }))
  default = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1" # -1 means all protocols
      cidr_block      = "0.0.0.0/0"
      rule_no         = 100
      action          = "allow"
    }
  ]
}

variable "sg_ingress_rules" {
  description = "List of ingress rules for the Security Group"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
    self             = bool
  }))
  default = [
    {
      description      = "Allow HTTP traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow SSH traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTP traffic"
      from_port        = 1024
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTP traffic"
      from_port        = 1024
      to_port          = 65535
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTP traffic"
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTP traffic"
      from_port        = 179
      to_port          = 179
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTP traffic"
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    }
  ]
}

variable "sg_egress_rules" {
  description = "List of egress rules for the Security Group"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
    self             = bool
  }))
  default = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    }
  ]
}

variable "sg_tags" {
  description = "Tags to apply to the Security Group"
  type        = map(string)
  default = {
    Name        = "sg_80_22_traffic"
    Environment = "default"
  }
} 

variable "aws_access_key_id" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = ""
}

# variable "region" {
#   description = "The CIDR block for the private subnet"
#   type        = string
#   default     = ""
# }