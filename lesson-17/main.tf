#------------------------------------------
# My Terraform
#
# Terraform Conditions and Lookups
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "prod_owner" {
  default = "Denis"
}

variable "noprod_owner" {
  default = "Eduard"
}

variable "ec2_size" {
  default = {
    "dev"     = "t2.micro"
    "prod"    = "t3.medium"
    "staging" = "t2.small"

  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

resource "aws_instance" "my_webserver1" {
  ami = "ami-0b6d9d3d33ba97d99"
  //instance_type = var.env == "prod" ? "t2.large" : "t2.micro"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}

resource "aws_instance" "my_webserver2" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = lookup(var.ec2_size, var.env)
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}

resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t2.micro"
  tags = {
    Name = "Bastion Server for Dev-server"
  }
}


resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
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

  tags = {
    Name  = "Dynamic Security Group"
    Owner = "Eduard Bondarenko"
  }
}
