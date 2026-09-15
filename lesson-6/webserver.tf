
#------------------------------------------
# My Terraform
#
# Build WebServer with lifecycle rules, zero downtime
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  domain   = "vpc"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Eduard",
    l_name = "Bondarenko",
    names  = ["Daniel", "John", "Donald", "Nicole", "Marco", "Anna", "Neta"]
  })

  tags = {
    Name  = "Webserver by Terraform"
    Owner = "Eduard Bondarenko"
  }

  user_data_replace_on_change = true

  lifecycle {
    #ignore_changes = ["ami", "user_data"]
    #prevent_destroy = true
    create_before_destroy = true
  }
}





resource "aws_security_group" "my_webserver" {
  name_prefix = "my_webserver-"
  description = "My first Security Group"

  dynamic "ingress" {
    for_each = ["80", "443"]
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
    Name = "my_webserver"
  }

  lifecycle {
    create_before_destroy = true
  }
}
