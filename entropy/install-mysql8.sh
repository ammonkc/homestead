#!/usr/bin/env bash

# Check If MySQL 8 Has Been Installed

if [ -f /home/vagrant/.mysql8 ]
then
    echo "MySQL 8 already installed."
    exit 0
fi

touch /home/vagrant/.mysql8

# Remove MySQL


# Add MySQL Repo
wget https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
sudo yum -y localinstall mysql80-community-release-el7-1.noarch.rpm

# check repos installed.
yum repolist enabled | grep "mysql.*-community.*"

sudo yum -y update
sudo yum -y install mysql-community-server

rm -f mysql80-community-release-el7-1.noarch.rpm

# find temporary password
mysql_password=`sudo grep 'temporary password' /var/log/mysqld.log | sed 's/.*localhost: //'`
mysqladmin -u root -p"$mysql_password" password secret
mysqladmin -u root -psecret variables | grep validate_password

# Configure MySQL 8 Remote Access
echo "bind-address = 0.0.0.0" | tee -a /etc/mysql/conf.d/mysql.cnf

# Use Native Pluggable Authentication
echo -e "[mysqld]\ndefault_authentication_plugin = mysql_native_password" | tee -a /etc/mysql/conf.d/mysql.cnf
sudo systemctl restart mysqld.service

mysql --user="root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'%' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'0.0.0.0' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
sudo systemctl restart mysqld.service
