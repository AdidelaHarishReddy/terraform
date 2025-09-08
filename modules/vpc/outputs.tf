output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.project_vpc[0].id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.project_vpc[0].arn, null)
}