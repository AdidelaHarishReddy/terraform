# module "ec2" {
#     source = "./modules/ec2"
# 	public_ip = aws_instance.example-ec2-instance.public_ip.id
# }
# output "s3_bucket_name" {
#     value = module.s3.bucket_id
#     description = "The name of the S3 bucket"
# }