#------------------------------------------
# Provision Highly Available Web in any Region Default VPC
# Create:
#     - Security Group for Web Server
#     - Launch Configuration with Auto AMI Lookup
#     - Auto Scaling Group using 2 Availability Zones
#     - Application Load Balancer in 2 Availability Zones
#
# Made by Eduard Bondarenko
#------------------------------------------



provider "aws" {
  region = "us-east-1"
}

# -------------------------
# Default VPC
# -------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "filtered" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}

locals {
  subnets = data.aws_subnets.filtered.ids
}

# -------------------------
# AMI (Amazon Linux 2023)
# -------------------------
data "aws_ami" "al2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Allow HTTP/HTTPS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# Launch Template
# -------------------------
resource "aws_launch_template" "web" {
  name_prefix   = "web-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = filebase64("${path.module}/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------
# Target Group
# -------------------------
resource "aws_lb_target_group" "tg" {
  name                 = "web-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.default.id
  deregistration_delay = 10

  health_check {
    path = "/"
  }
}

# -------------------------
# Application Load Balancer
# -------------------------
resource "aws_lb" "alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.web.id]
  subnets         = local.subnets
}

# -------------------------
# Listener
# -------------------------
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# -------------------------
# Auto Scaling Group
# -------------------------
resource "aws_autoscaling_group" "web" {
  name = "asg-${aws_launch_template.web.name}"

  min_size         = 2
  max_size         = 2
  desired_capacity = 2

  vpc_zone_identifier = local.subnets

  target_group_arns = [
    aws_lb_target_group.tg.arn
  ]

  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------
# Output
# -------------------------
output "alb_dns" {
  value = aws_lb.alb.dns_name
}

