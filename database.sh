#!/bin/bash
set -e

apt update -y
apt install -y mariadb-server myphpadmin php php-mysql libapache2-mod-php apache2

systemctl enable mariadb
systemctl start mariadb

# Allow remote connection
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

systemctl restart mariadb

# Create database & user
mysql <<EOF
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'heralt'@'%' IDENTIFIED BY 'heralt';
GRANT ALL PRIVILEGES ON moodle.* TO 'heralt'@'%';
FLUSH PRIVILEGES;
EOF

clear

history -c
