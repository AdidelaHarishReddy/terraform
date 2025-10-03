resource "aws_ebs_volume" "ebs_10gb" {
    availability_zone = var.availability_zone
    size = var.size
    tags = {
        Name = "ebs_10gb"
    }
  
}