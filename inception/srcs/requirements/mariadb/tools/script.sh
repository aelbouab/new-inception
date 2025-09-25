#!/bin/bash
set -e

mysqld_safe --skip-networking &

echo "Waiting for MariaDB to start..."
until mysqladmin ping --silent; do
  sleep 1
done

cat <<EOF > /tmp/data.sql
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysql < /tmp/data.sql

mysqladmin shutdown

chown -R mysql:mysql /var/lib/mysql

exec gosu mysql mysqld

