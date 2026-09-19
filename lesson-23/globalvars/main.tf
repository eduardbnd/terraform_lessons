#------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3 Bucket
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "eduard-bondarenko-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

#----------------------------------------------------------

output "company_name" {
  value = "ANDESA"
}

output "owner" {
  value = "Eduard Bondarenko"
}

output "tags" {
  value = {
    Project    = "Terraform Lessons"
    CostCenter = "DevOps"
    Country    = "USA"
  }
}
