#! /bin/bash

echo "======================= update repository ======================="
sudo yum update -y

echo "======================= install apache2/httpd ======================="
sudo yum install httpd -y

echo "======================= creat index.html ======================="
sudo echo "<h1><center>Hallo from terraform aws-linux</center></h1>" > /var/www/html/index.html

echo "======================= start apache2/httpd ======================="
sudo service httpd start