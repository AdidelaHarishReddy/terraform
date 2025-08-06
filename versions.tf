terraform {
  required_version = "1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.6"
    }
  }
}

terraform {
  backend "s3" {
        bucket       = "my-unique-bucket-name-harish-terraform"  
        key          = "main/terraform.tfstate"  
        region       = "ap-south-1"  
        encrypt      = true  
        use_lockfile = true
  }
}