#!/bin/bash
set -e

apt update -y
apt install -y apache2 php8.1 libapache2-mod-php8.1 php8.1-cli php8.1-mysql php8.1-gd php8.1-xml php8.1-curl php8.1-mbstring php8.1-intl php8.1-zip php8.1-soap php8.1-bcmath wget

systemctl enable apache2
systemctl start apache2

cd /var/www/html/
# Menghapus file index default apache agar tidak bentrok jika ingin moodle di root
rm -f index.html 

wget https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz
tar -zxvf moodle-latest-405.tgz
rm moodle-latest-405.tgz

mkdir -p /var/www/moodledata
chown -R www-data:www-data /var/www/moodledata
chmod -R 777 /var/www/moodledata

chown -R www-data:www-data /var/www/html
chmod -R 777 /var/www/html

# 4. Optimasi PHP 8.1
PHPINI="/etc/php/8.1/apache2/php.ini"
# Menggunakan pemisah | agar lebih aman jika ada karakter khusus
sed -i 's|^;max_input_vars.*|max_input_vars = 5000|' $PHPINI
sed -i 's|^max_input_vars = .*|max_input_vars = 5000|' $PHPINI
sed -i 's|^memory_limit = .*|memory_limit = 512M|' $PHPINI
sed -i 's|^post_max_size = .*|post_max_size = 100M|' $PHPINI
sed -i 's|^upload_max_filesize = .*|upload_max_filesize = 100M|' $PHPINI

# 5. Konfigurasi VirtualHost Apache (Agar SSL Proxy Cloudflare Dikenali)
# Kita tambahkan baris untuk menangani HTTPS dari Cloudflare secara pasif
cat <<EOF > /etc/apache2/sites-available/moodle.conf
<VirtualHost *:80>
    ServerName moodle.geraldstudio.my.id
    DocumentRoot /var/www/html/moodle

    <Directory /var/www/html/moodle>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

a2ensite moodle.conf
a2dissite 000-default.conf
a2enmod rewrite
systemctl restart apache2

clear

echo "URL: https://moodle.geraldstudio.my.id
echo "$CFG->sslproxy = 1;"

history -c 

cat /dev/null > ~/.bash_history 

set +o history
