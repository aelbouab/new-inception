#!/bin/bash
set -e

# Start MariaDB safely in the background, skip networking for init
mysqld_safe --skip-networking &

# Wait until MariaDB is ready
echo "Waiting for MariaDB to start..."
until mysqladmin ping --silent; do
  sleep 1
done

# Run initialization SQL commands
cat <<EOF > /tmp/data.sql
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysql < /tmp/data.sql

# Shut down the background MariaDB instance cleanly
mysqladmin shutdown

# Make sure data directory has correct ownership (adjust path if needed)
chown -R mysql:mysql /var/lib/mysql

# Run mysqld as mysql user in the foreground to keep container alive
exec gosu mysql mysqld

