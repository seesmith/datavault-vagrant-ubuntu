#!/usr/bin/env bash

apt-get update



# Install Mysql
debconf-set-selections <<< 'mysql-server mysql-server/root_password password datavault'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password datavault'
apt-get install -y mysql-server 

# todo : insert something here to edit the Mysql char set

# Create the database
cat /vagrant/datavault_database_create.sql | mysql -u root -pdatavault



# Add the RabbitMQ repository and signing key to the package manager
# See: https://www.rabbitmq.com/install-debian.html
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
apt-get update

# Install packages
apt-get install -y rabbitmq-server

# Configure RabbitMQ users
# In this example the password is 'datavault'
rabbitmqctl add_user datavault datavault
rabbitmqctl set_user_tags datavault administrator
rabbitmqctl set_permissions -p / datavault ".*" ".*" ".*"



# Java (Should be Openjre version 8)
apt-get install -y default-jre

# Tomcat
apt-get install -y tomcat7

