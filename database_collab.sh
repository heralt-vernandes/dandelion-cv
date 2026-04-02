#!/bin/bash
# Script Database Khusus Google Colab
set -e

echo "Menginstall MariaDB..."
apt update -y
apt install -y mariadb-server php-mysql

# WAJIB: Jalankan MariaDB dulu sebelum konfigurasi DB
echo "Menjalankan MariaDB Service..."
/etc/init.d/mariadb start

# Tunggu sebentar agar socket MariaDB siap
sleep 2

# Konfigurasi Akses (Agar bisa di-remote jika perlu)
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
/etc/init.d/mariadb restart

# Membuat Database dan User
echo "Membuat Database Moodle..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'heralt'@'%' IDENTIFIED BY 'heralt';
GRANT ALL PRIVILEGES ON moodle.* TO 'heralt'@'%';
FLUSH PRIVILEGES;
EOF

echo "--- DATABASE SIAP ---"
