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

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.cidr_block
  vpc_name  = var.vpc_name
}

module "IGW" {
  depends_on = [ module.vpc ]
  source = "./modules/IGW"
  # Example variables, replace with your actual variable names and values
  vpc_id = module.vpc.vpc_id
}

module "pub_route_table" {
  depends_on = [ module.vpc, module.IGW ]
  source = "./modules/route_table"  
  # Example variables, replace with your actual variable names and values
  vpc_id          = module.vpc.vpc_id
  subnet_cidr     = var.pub_subnet_cidr
  igw_id          = module.IGW.igw_id
  routetable_name = { Name = "pub_route_table" }
}

module "pvt_route_table" {
  depends_on = [ module.vpc ]
  source = "./modules/route_table"
  # Example variables, replace with your actual variable names and values
  vpc_id          = module.vpc.vpc_id
  subnet_cidr     = var.pvt_subnet_cidr
  routetable_name = { Name = "pvt_route_table" }
}

# resource "aws_route" "pub_route" {
#   route_table_id         = module.pub_route_table.id
#   destination_cidr_block = "10.0.2.0/24"
#   gateway_id             = module.IGW.igw_id
#   vpc_id = module.vpc.vpc_id
#   depends_on = [ module.IGW ]
# }

# resource "aws_route" "pvt_route" {
#   route_table_id         = module.pvt_route_table.id
#   destination_cidr_block = "10.0.1.0/24"
#   vpc_id = module.vpc.vpc_id
# }

module "pub_subnet" {
  depends_on = [ module.pub_route_table, module.nacl ]
  source = "./modules/subnet"
  # Example variables, replace with your actual variable names and values
  vpc_id                  = module.vpc.vpc_id # Reference to your existing VPC
  # nacl_id                 = module.nacl.nacl_id
  subnet_cidr             = var.pub_subnet_cidr
  subnet_name             = "public-subnet-1"
  map_public_ip_on_launch = true
}

module "pvt_subnet" {
  depends_on = [ module.pub_route_table, module.nacl ]
  source = "./modules/subnet"

  # Example variables, replace with your actual variable names and values
  vpc_id                  = module.vpc.vpc_id # Reference to your existing VPC
  subnet_cidr             = var.pvt_subnet_cidr
  subnet_name             = "private-subnet-1"
  map_public_ip_on_launch = false
}


module "nacl" {
  source        = "./modules/NACL"
  vpc_id        = module.vpc.vpc_id
  nacl_name     = "nacl_80_22_traffic"
}

locals {
  subnet_map = {
    "pvt" = module.pvt_subnet.subnet_id
    "pub" = module.pub_subnet.subnet_id
  }
}

resource "aws_network_acl_association" "nacl_association" {
  for_each = local.subnet_map
  subnet_id     = each.value
  network_acl_id = module.nacl.nacl_id
}

# # Associate the NACL with the provided subnets..
# resource "aws_network_acl_association" "nacl_association" {
#   for_each       = toset([module.pvt_subnet.subnet_id, module.pub_subnet.subnet_id])
#   subnet_id      = each.value
#   network_acl_id = module.nacl.nacl_id
# }

module "SG" {
  source = "./modules/sg"

  # Example variables, replace with your actual variable names and values..
  vpc_id = module.vpc.vpc_id
  ingress_rules = var.sg_ingress_rules
  sg_tags       = var.sg_tags
}

module "master_vm" {
  source = "./modules/ec2"

  # Example variables, replace with your actual variable names and values
instance_type        = var.m_instance_type
  count               = var.m_node_count
  region              = var.region
  key_name             = var.key_name
  vpc_id             = module.vpc.vpc_id        # Uncomment if using VPC ID
  subnet_ids         = [module.pub_subnet.subnet_id]    # Uncomment if using subnet IDs
  security_group_ids = [module.SG.sg_id]
  tags                = var.m_tags
  ami                  = "ami-0f918f7e67a3323f0"  # Add other variables as required by your ec2 module
  # tags = {
  #   Name = "example-ec2-instance"
  # }
  # Add other variables as required by your ec2 module
}

resource "null_resource" "master_provision" {
  triggers = {
    run_at = "only-once"
  }
  count = var.m_node_count

  # triggers = {
  #   always_run = timestamp()
  # }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/anand/Downloads/mahesh1.pem")
    host        = module.master_vm[count.index].public_ips[0]

  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "sudo apt update || echo \"apt update failed\"",
      "curl -s https://raw.githubusercontent.com/AdidelaHarishReddy/installations/refs/heads/main/k8s_master_worker_new | bash -s master | tee -a /home/ubuntu/master-log.txt || echo \"Failed to run master setup script\"",
      "sleep 10",
      "sudo kubeadm token create --print-join-command > /home/ubuntu/join_command.sh || echo \"Failed to create join command\"",
      "cat /home/ubuntu/join_command.sh | tee -a /home/ubuntu/log.txt"

    ]
  }
  provisioner "local-exec" {
    command = "scp -i C:/Users/anand/Downloads/mahesh1.pem -o StrictHostKeyChecking=no ubuntu@${module.master_vm[count.index].public_ips[0]}:/home/ubuntu/join_command.sh ./join_command.sh"
}
}

module "worker_vm" {
  source = "./modules/ec2"

  # Example variables, replace with your actual variable names and values
instance_type        = var.instance_type
  count               = var.node_count
  region              = var.region
  key_name             = var.key_name
  vpc_id             = module.vpc.vpc_id        # Uncomment if using VPC ID
  subnet_ids         = [module.pub_subnet.subnet_id]      # Uncomment if using subnet IDs
  security_group_ids = [module.SG.sg_id]
  tags                = var.tags
  ami                  = "ami-0f918f7e67a3323f0"  # Add other variables as required by your ec2 module

}

resource "null_resource" "worker_provision" {
  triggers = {
    run_at = "only-once"
  }
  depends_on = [ null_resource.master_provision, module.worker_vm ]
  count = var.node_count

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/anand/Downloads/mahesh1.pem")
    host        = module.worker_vm[count.index].public_ips[0]
  }
#   provisioner "local-exec" {
#     command = "sleep 30 ; scp ./join_command.sh -i C:/Users/anand/Downloads/mahesh1.pem -o StrictHostKeyChecking=no ubuntu@${module.worker_vm[count.index].public_ips[0]}:/home/ubuntu/join_command.sh "
#   }

provisioner "file" {
  source      = "./join_command.sh"
  destination = "/home/ubuntu/join_command.sh"
}

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "curl -s https://raw.githubusercontent.com/AdidelaHarishReddy/installations/refs/heads/main/k8s_master_worker_new | bash -s worker",
      "sudo chmod +x /home/ubuntu/join_command.sh",
      "sudo bash /home/ubuntu/join_command.sh"
    ]
  }
}

