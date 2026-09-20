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

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "Webserver by Terraform"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "my_webserver"
  description = "My first Security Group"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

