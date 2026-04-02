#!/bin/bash
# Script untuk Website Moodle di Google Colab

apt update
apt install -y apache2 php8.1 libapache2-mod-php8.1 php8.1-cli php8.1-mysql php8.1-gd php8.1-xml php8.1-curl php8.1-mbstring php8.1-intl php8.1-zip php8.1-soap php8.1-bcmath wget

# Jalankan Apache manual
/etc/init.d/apache2 start

# Download & Setup Moodle
cd /var/www/html/
rm -f index.html
wget https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz
tar -zxvf moodle-latest-405.tgz
rm moodle-latest-405.tgz

mkdir -p /var/www/moodledata
chown -R www-data:www-data /var/www/moodledata /var/www/html/moodle
chmod -R 775 /var/www/moodledata
chmod -R 755 /var/www/html/moodle

echo "Apache & Moodle siap di background!"
