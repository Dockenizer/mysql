#!/bin/bash
set -e

if [ "${uid}" != "" ]
then
    usermod -u $uid mysql
fi


chown -R mysql:mysql /var/lib/mysql
mysql_install_db

file=`mktemp`

cat << EOF > $file
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

DROP DATABASE test;

EOF

/usr/sbin/mysqld --bootstrap --verbose=0 < $file
rm -f $file

chown -R mysql:mysql /var/lib/mysql
exec /usr/bin/mysqld_safe