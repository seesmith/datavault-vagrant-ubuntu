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

cp /vagrant/envvars.sh /usr/share/tomcat7/bin/setenv.sh
sed -i 's/webapps/\/vagrant_datavault-home\/webapps/' /etc/tomcat7/server.xml
service tomcat7 restart
 

# Start the Worker(s)
. /vagrant/envvars.sh
export DATAVAULT_HOME=/vagrant_datavault-home
chmod 777 /vagrant_datavault-home/bin/start-worker.sh
. /vagrant_datavault-home/bin/start-worker.sh

# Some dummy data (if using 'local storage')
mkdir -p /Users
touch /Users/file1
touch /Users/dir1

# Directory for archive data (if using 'local storage')
mkdir -p /tmp/datavault/archive
# A temporary directory for workers to process files before storing in the archive
mkdir -p /tmp/datavault/temp
# A directory for storing archive metadata
mkdir -p /tmp/datavault/meta
