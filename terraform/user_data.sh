#!/bin/bash
sudo yum update
# instalação do mysql e do servidor apache
sudo yum install -y mysql
sudo yum install -y httpd
sudo service httpd start
# Dependencias do Wordpress
sudo amazon-linux-extras install -y php8.2
#Download e extração do Wordpress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
#Faz o wordpress rodar como usuario apache
chown -R apache:apache /var/www/html/
rm -rf wordpress latest.tar.gz