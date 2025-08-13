#!/bin/sh

sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

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
fi

if ! wp core is-installed --allow-root; then
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN_USR" \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

if ! wp user list --field=user_login --allow-root | grep -q "^$WP_USR$"; then
    wp user create "$WP_USR" "$WP_EMAIL" \
        --user_pass="$WP_PWD" --allow-root
else
    echo "User '$WP_USR' already exists, skipping creation."
fi

exec /usr/sbin/php-fpm7.4 -F