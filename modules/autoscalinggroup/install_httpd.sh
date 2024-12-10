#!/bin/bash
sudo systemctl stop httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo chmod -R 777 /var/www
sudo echo "<h1>Welcome to ACS730 Project! My private IP is $myip</h1><br>"  >  /var/www/html/index.html
sudo echo '<h1>Team Member 1: Haojie Fu</h1><br>' >> /var/www/html/index.html
sudo echo '<h1>Team Member 2: Rentian Zhang</h1><br>' >> /var/www/html/index.html
sudo echo '<img src="https://acs730-images.s3.us-east-1.amazonaws.com/merry_christmas.jpg" />' >> /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
