#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<br>"Hello World!!" >> /var/www/html/index.html
echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
EOF