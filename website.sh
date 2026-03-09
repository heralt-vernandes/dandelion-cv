#!/bin/bash
set -e

apt update -y
apt install -y apache2 php8.1 libapache2-mod-php8.1 php8.1-cli php8.1-mysql php8.1-gd php8.1-xml php8.1-curl php8.1-mbstring php8.1-intl php8.1-zip php8.1-soap php8.1-bcmath wget

systemctl enable apache2
systemctl start apache2

cd /var/www/html/

wget https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz
tar -zxvf moodle-latest-405.tgz
rm moodle-latest-405.tgz

mkdir -p /var/www/moodledata

chown -R www-data:www-data /var/www/moodledata
chmod -R 775 /var/www/moodledata

chown -R www-data:www-data /var/www/html/moodle
chmod -R 755 /var/www/html/moodle

# Configure PHP 8.1
PHPINI="/etc/php/8.1/apache2/php.ini"

sed -i 's/^;max_input_vars.*/max_input_vars = 5000/' $PHPINI
sed -i 's/^max_input_vars = .*/max_input_vars = 5000/' $PHPINI

sed -i 's/^memory_limit = .*/memory_limit = 512M/' $PHPINI
sed -i 's/^post_max_size = .*/post_max_size = 100M/' $PHPINI
sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 100M/' $PHPINI

systemctl restart apache2
clear
