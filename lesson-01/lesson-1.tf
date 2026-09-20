#------------------------------------------
# My Terraform
#
# Build WebServer during Bootsrap
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my_ubuntu" {
  count         = 2
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t3.micro"
  tags = {
    Name    = "my ubuntu server"
    Owner   = "eduard bondarenko"
    Project = "terraform lessons"
  }
}

resource "aws_instance" "my_amazon_linux" {
  ami           = "ami-0236922087fa98b6e"
  instance_type = "t3.small"
  tags = {
    Name    = "my amazon server"
    Owner   = "eduard bondarenko"
    Project = "terraform lessons"
  }
}

