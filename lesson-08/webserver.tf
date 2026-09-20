
#------------------------------------------
# My Terraform
#
# Build WebServer with outputs
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my_webserver_web" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server Web"
  }
  depends_on = [aws_instance.my_webserver_app]
}

resource "aws_instance" "my_webserver_app" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server Application"
  }
  depends_on = [aws_instance.my_webserver_db]
}

resource "aws_instance" "my_webserver_db" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Server Database"
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

}

