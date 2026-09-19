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

data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = "eduard-bondarenko-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  company_name = data.terraform_remote_state.globalvars.outputs.company_name
  owner        = data.terraform_remote_state.globalvars.outputs.owner
  common_tags  = data.terraform_remote_state.globalvars.outputs.tags
}

#----------------------------------------------------------

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "Stack2-VPC1"
    Company = local.company_name
    Owner   = local.owner
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.common_tags, { Name = "Stack2-VPC2" })
}
