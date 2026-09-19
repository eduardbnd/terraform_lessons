provider "aws" {
  region = "us-east-1"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo \"Terraform START: $(date)\" >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
  depends_on = [null_resource.command1]
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print('Hello from Python!')"
    interpreter = ["python3", "-c"]
  }
  depends_on = [null_resource.command2]
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo \"$NAME1 $NAME2 $NAME3\" >> names.txt"

    environment = {
      NAME1 = "Eduard"
      NAME2 = "Bondarenko"
      NAME3 = "DevOps"
    }
  }
  depends_on = [null_resource.command3]
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo Hello from AWS Instance Creation!"
  }

  tags = {
    Name = "MyInstance"
  }
}

resource "null_resource" "command5" {
  provisioner "local-exec" {
    command = "echo \"Terraform END: $(date)\" >> log.txt"
  }

  depends_on = [
    null_resource.command1,
    null_resource.command2,
    null_resource.command3,
    null_resource.command4,
    aws_instance.my_instance
  ]
}