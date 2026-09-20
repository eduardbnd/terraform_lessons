#------------------------------------------
# My Terraform
#
# Data Source
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "subnet_prod_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.1.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "subnet_prod_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "172.31.2.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}


output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names[1]
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "aws_vpc" {
  value = data.aws_vpc.prod_vpc
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}

