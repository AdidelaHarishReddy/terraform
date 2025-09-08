output "subnet_id" {
  description = "The ID of the Subnet"
  value       = try(aws_subnet.subnet.id, null)
}
