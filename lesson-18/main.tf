#------------------------------------------
# My Terraform
#
# Terraform Loops: Count and For if
#
# Made by Eduard Bondarenko
#------------------------------------------

provider "aws" {
  region = "us-east-1"
}

variable "aws_users" {
  description = "List of AWS users"
  default     = ["Denis", "John", "Mike", "Alex", "Tom", "Jerry"]
}

resource "aws_iam_user" "user1" {
  name = "Eduard"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

output "created_iam_users" {
  value = aws_iam_user.users
}

output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}

output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name} has ARN ${user.arn}"
  ]
}

output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id
  }
}

// Print List of Users with Name Length 4
output "custom_if_length" {
  value = [
    for user in aws_iam_user.users :
    user.name
    if length(user.name) == 4
  ]
}

#------------------------------------------------------

resource "aws_instance" "servers" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t2.micro"
  count         = 3
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}

//Print List of Servers with Public IPs
output "created_servers" {
  value = {
    for server in aws_instance.servers :
    server.id => server.public_ip
  }
}
