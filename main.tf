resource "aws_s3_bucket" "bucket" {
  bucket = "my-unique-bucket-name-harish-terraform1212"
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

module "master_vm" {
  source = "./modules/ec2"

  # Example variables, replace with your actual variable names and values
instance_type        = var.m_instance_type
  count               = var.m_node_count
  region              = var.region
  key_name             = var.key_name
  # vpc_id             = var.vpc_id        # Uncomment if using VPC ID
  # subnet_ids         = var.subnet_ids    # Uncomment if using subnet IDs
  tags                = var.m_tags
  ami                  = "ami-0f918f7e67a3323f0"  # Add other variables as required by your ec2 module
  # tags = {
  #   Name = "example-ec2-instance"
  # }
  # Add other variables as required by your ec2 module
}

resource "null_resource" "master_provision" {
  count = var.m_node_count

  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/anand/Downloads/${var.key_name}")
    host        = module.master_vm[count.index].public_ips[0]

  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "curl -s https://raw.githubusercontent.com/AdidelaHarishReddy/installations/refs/heads/main/k8s_master_worker | bash -s master",
      " kubeadm token create --print-join-command > /home/ubuntu/join_command.sh"
    ]
  }
  provisioner "local-exec" {
    command = "scp -i C:/Users/anand/Downloads/venu2.pem -o StrictHostKeyChecking=no ubuntu@${module.master_vm[count.index].public_ips[0]}:/home/ubuntu/join_command.sh ./join_command.sh"
}
}

module "worker_vm" {
  source = "./modules/ec2"

  # Example variables, replace with your actual variable names and values
instance_type        = var.instance_type
  count               = var.node_count
  region              = var.region
  key_name             = var.key_name
  # vpc_id             = var.vpc_id        # Uncomment if using VPC ID
  # subnet_ids         = var.subnet_ids    # Uncomment if using subnet IDs
  tags                = var.tags
  ami                  = "ami-0f918f7e67a3323f0"  # Add other variables as required by your ec2 module

}

resource "null_resource" "worker_provision" {
  count = var.node_count

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/anand/Downloads/${var.key_name}")
    host        = module.worker_vm[count.index].public_ips[0]
  }
  provisioner "local-exec" {
    command = "scp ./join_command.sh -i C:/Users/anand/Downloads/venu2.pem -o StrictHostKeyChecking=no ubuntu@${module.worker_vm[count.index].public_ips[0]}:/home/ubuntu/join_command.sh "
}

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "curl -s https://raw.githubusercontent.com/AdidelaHarishReddy/installations/refs/heads/main/k8s_master_worker | bash -s worker",
      "sudo chmod +x /home/ubuntu/join_command.sh",
      "sudo bash /home/ubuntu/join_command.sh"
    ]
  }
}

