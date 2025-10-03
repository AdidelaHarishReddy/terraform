variable "availability_zone" {
    description = "The availability zone to create the EBS volume in"
    type = string
    default = "ap-south-1a"
}

variable "size" {
    description = "The size of the EBS volume in GB"
    type = number
    default = 10
}