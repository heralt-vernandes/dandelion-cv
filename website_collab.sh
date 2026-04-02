#!/bin/bash
# Script Website Khusus Google Colab
set -e

echo "Menginstall Apache & PHP 8.1..."
apt update -y
apt install -y apache2 php8.1 libapache2-mod-php8.1 php8.1-cli php8.1-mysql php8.1-gd php8.1-xml php8.1-curl php8.1-mbstring php8.1-intl php8.1-zip php8.1-soap php8.1-bcmath wget

# Jalankan Apache
echo "Menjalankan Apache Service..."
/etc/init.d/apache2 start

# Setup Moodle
echo "Mendownload Moodle..."
cd /var/www/html/
rm -f index.html
if [ ! -d "moodle" ]; then
    wget https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz
    tar -zxvf moodle-latest-405.tgz
    rm moodle-latest-405.tgz
fi

# Setup Permission
echo "Mengatur Permission..."
mkdir -p /var/www/moodledata
chown -R www-data:www-data /var/www/moodledata
chown -R www-data:www-data /var/www/html/moodle
chmod -R 775 /var/www/moodledata
chmod -R 755 /var/www/html/moodle

echo "--- WEBSITE SIAP ---"
