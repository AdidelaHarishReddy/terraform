# module "ec2" {
#     source = "./modules/ec2"
# 	public_ip = aws_instance.example-ec2-instance.public_ip.id
# }
# output "s3_bucket_name" {
#     value = module.s3.bucket_id
#     description = "The name of the S3 bucket"
# }
output "public_ips" {
  description = "The public IP addresses of the EC2 instances"
  value       = module.master_vm[*].public_ips
}
output "worker_public_ips" {
  description = "The public IP addresses of the worker EC2 instances"
  value       = module.worker_vm[*].public_ips
}

output "nacl_id" {
  description = "ID of the created NACL"
  value       = module.nacl.id
}