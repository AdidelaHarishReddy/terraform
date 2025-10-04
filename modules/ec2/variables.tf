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

variable "instance_type" {
    description = "Instance type for the cluster nodes"
    type        = string
    default     = "t3.micro"
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
    default     = {"Name" = "master-k8s"}
}

variable "ami" {
    description = "AMI ID for the EC2 instances"
    type        = string
    default     = "ami-0f918f7e67a3323f0"  # Example AMI ID, replace with a valid
}

variable "key_name" {
    description = "The name of the key pair to use for the EC2 instances"
    type        = string
    default     = "mahesh1"  # Replace with your actual key name
}

# Security groups to attach to instances
variable "security_group_ids" {
    description = "List of security group IDs to associate with instances"
    type        = list(string)
    default     = []
}

variable "associate_public_ip_address" {
    description = "Whether to associate a public IP address with the instance"
    type        = bool
    default     = false
}

variable "root_volume_size" {
    description = "Root EBS volume size in GB for the EC2 instance"
    type        = number
    default     = 8
}

# variable "ebs_volume_id" {
#     description = "ebs adding volume value"  
#     type        = string
#     default     = "aws_ebs_volume.ebs_10gb.id"
# }