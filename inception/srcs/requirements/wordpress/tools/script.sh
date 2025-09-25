#!/bin/sh

sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

wp core download --allow-root

echo "Waiting for MariaDB..."

sleep 10

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp config create --skip-check \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root
   
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN_USR" \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
    
    wp user create "$WP_USR" "$WP_EMAIL" \
        --user_pass="$WP_PWD" --allow-root
fi


exec /usr/sbin/php-fpm8.2 -F