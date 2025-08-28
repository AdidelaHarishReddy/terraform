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

# variable "vpc_id" {
#     description = "The VPC ID where the cluster will be deployed"
#     type        = string
# }

# variable "subnet_ids" {
#     description = "A list of subnet IDs for the cluster"
#     type        = list(string)
# }

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
    default     = "venu2"  # Replace with your actual key name
}

