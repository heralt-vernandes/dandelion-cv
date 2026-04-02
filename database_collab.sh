#!/bin/bash
# Script untuk Database di Google Colab (Tanpa Systemd)

apt update
apt install -y mariadb-server phpmyadmin php-mysql

# Fix Service: Colab tidak mendukung systemctl, pakai init.d
/etc/init.d/mariadb start

# Konfigurasi agar bisa diakses dari "luar" (simulasi antar CT)
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
/etc/init.d/mariadb restart

# Create database & user untuk Moodle
mysql <<EOF
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'heralt'@'%' IDENTIFIED BY 'heralt';
GRANT ALL PRIVILEGES ON moodle.* TO 'heralt'@'%';
FLUSH PRIVILEGES;
EOF

echo "Database MariaDB siap di background!"
