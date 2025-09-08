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

variable "igw_id" {
  description = "The ID of the internet gateway"
  type        = string
  default     = ""
}

variable "routetable_name" {
  description = "Name of the route table"
  type        = map(string)
  default     = {
    Name = "public-route-table"
  }
}