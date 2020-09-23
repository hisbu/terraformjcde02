#! /bin/bash

echo "======================= update repository ======================="
sudo apt update

echo "======================= install apache2 ======================="
sudo apt install apache2 -y

echo "======================= creat index.html ======================="
sudo echo "<h1><center>Hallo from terraform $(hostname -f)</center></h1>" > /var/www/html/index.html