module "ec2" {
  source = "./modules/ec2"

  # Example variables, replace with your actual variable names and values
  instance_type        = "t2.micro"
  ami                  = "ami-0f918f7e67a3323f0"
  key_name             = "venu2"
  tags = {
    Name = "example-ec2-instance"
  }
  # Add other variables as required by your ec2 module
}

# module "s3" {
#   source  = "clouddrove/s3/aws"
#   version = "2.0.0"
# #}
resource "aws_s3_bucket" "bucket" {
  bucket = "my-unique-bucket-name-harish-terraform"
}
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
