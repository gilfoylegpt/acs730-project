#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo systemctl stop httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Haojie Fu, Welcome to ACS730 Project! My private IP is $myip</h1><br>Built by Terraform!"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
