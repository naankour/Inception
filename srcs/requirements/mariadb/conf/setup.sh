#!/bin/bash
set -x

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --skip-networking --skip-grant-tables &
sleep 10

until mysql -u root -e "SELECT 1" > /dev/null 2>&1; do
    echo "En attente de MariaDB..."
    sleep 2
done

mysql -u root << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
sleep 2

exec mysqld_safe