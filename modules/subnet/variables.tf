variable "vpc_id" {
  description = "The ID of the VPC to attach the internet gateway to"
  type        = string
  default     = ""
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = ""
}

variable "map_public_ip_on_launch" {
  description = "Whether to map public IP addresses on launch"
  type        = bool
  default     = false
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "subnet"
}