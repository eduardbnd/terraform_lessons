#!/bin/bash
yum update -y
yum install -y httpd

systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Hello from EC2</title>
</head>
<body>
    <h1>Apache v4 is running!</h1>
    <p>Server: $(hostname)</p>
    <p>Time: $(date)</p>
</body>
</html>
EOF