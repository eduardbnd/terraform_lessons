#------------------------------------------
# My Terraform
#
# Provision Resources in Multiple AWS Regions / Accounts
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = "us-east-1"
  #assume_role {
  #role_arn     = "arn:aws:iam:123456789:role/RemoteAdministrators"
  #session_name = "Terraform Session"
  #}
}

provider "aws" {
  region = "us-west-1"
  alias  = "West"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "Ger"
}

#==============================================

resource "aws_instance" "my_east_server" {
  instance_type = "t3.micro"
  ami           = "ami-0b6d9d3d33ba97d99"
  tags = {
    Name = "East Server"
  }
}

resource "aws_instance" "my_west_server" {
  provider      = aws.West
  instance_type = "t3.micro"
  ami           = "ami-0fb110df4c5094d21"
  tags = {
    Name = "West Server"
  }
}

resource "aws_instance" "my_ger_server" {
  provider      = aws.Ger
  instance_type = "t3.micro"
  ami           = "ami-06121aa3085b6f918"
  tags = {
    Name = "Germany Server"
  }
}