#------------------------------------------
# My Terraform
#
# Find latest AMI ID of:
#       - Ubuntu 18.04
#       - Amamzon Linux 2
#       - Windows Server 2016 Base
#
# Made by Eduard Bondarenko
#------------------------------------------



provider "aws" {
  region = "ap-southeast-2"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazon_linux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.18-x86_64"]
  }
}

data "aws_ami" "latest_windows" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2025-English-Full-Base-*"]
  }
}

resource "aws_instance" "my_webserver_ubuntu" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro"
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_amazonlinux_ami_id" {
  value = data.aws_ami.latest_amazon_linux2.id
}

output "latest_amazonlinux_ami_name" {
  value = data.aws_ami.latest_amazon_linux2.name
}

output "latest_windows_ami_id" {
  value = data.aws_ami.latest_windows.id
}

output "latest_windows_ami_name" {
  value = data.aws_ami.latest_windows.name
}

