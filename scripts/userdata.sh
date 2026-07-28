#!/bin/bash
yum update -y
yum install -y httpd stress
systemctl start httpd
systemctl enable httpd

# Fetch EC2 instance metadata to display on the webpage
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Build a dynamic webpage that proves which server is responding
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>AWS Auto Scaling Architecture</title>
    <style>body { font-family: 'Segoe UI', Tahoma, sans-serif; text-align: center; padding: 50px; background-color: #f4f7f6; }</style>
</head>
<body>
  <h1> Highly Available Multi-AZ App</h1>
  <p>If you refresh this page, the Instance ID will change as the Load Balancer shifts traffic!</p>
  <h2 style="color: #ff9900;">Responding from AZ: \${AZ}</h2>
  <h3>Server ID: \${INSTANCE_ID}</h3>
</body>
</html>
EOF