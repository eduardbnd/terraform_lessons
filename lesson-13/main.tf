#------------------------------------------
# My Terraform
#
# Autofill Variables
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amazon_linux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.18-x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  tags     = var.common_tags
  /*
  tags = {
    Name    = "Server IP"
    Owner   = "Eduard Bondarenko"
    Project = "Phoenix"
  } */
}

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.latest_amazon_linux2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_server.id]
  monitoring             = var.enable_detailed_monitoring

  tags = var.common_tags
}


resource "aws_security_group" "my_server" {
  name = "My Security Group"

  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.common_tags
}
