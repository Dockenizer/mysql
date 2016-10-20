#!/bin/bash
set -e

if [ "${uid}" != "" ]
then
    usermod -u $uid mysql
fi


chown -R mysql:mysql /var/lib/mysql
mysql_install_db

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
MYSQL_ROOT_LOGIN=${MYSQL_ROOT_LOGIN:-"root"}

file=`mktemp`

echo "USE mysql;
      DELETE FROM mysql.user;" >> $file;

echo "INSERT INTO mysql.user VALUES('','${MYSQL_ROOT_LOGIN}', PASSWORD('${MYSQL_ROOT_PASSWORD}'),'Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y', 'Y', '', '', '', '', 0, 0, 0, 0, '', '', 'N', 'N', '', 0.000000);" >> $file;

echo "DROP DATABASE IF EXISTS test ;
      FLUSH PRIVILEGES;" >> $file;

/usr/bin/mysqld --bootstrap --verbose=0 < $file
rm -f $file

chown -R mysql:mysql /var/lib/mysql
exec /usr/bin/mysqld_safe