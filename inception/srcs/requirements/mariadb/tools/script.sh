#!/bin/bash

# Start MariaDB service temporarily for initialization
service mariadb start

# Wait for MariaDB to be ready
sleep 5

# Create database, user, and grant privileges
cat <<EOF > /tmp/data.sql
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Execute the SQL commands
mysql < /tmp/data.sql

# Stop the temporary MariaDB service and start mysqld daemon
service mariadb stop
exec mysqld