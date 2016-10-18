#!/bin/bash
set -e

if [ "${uid}" != "" ]
then
    usermod -u $uid mysql
fi


chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user=root

file=`mktemp`

cat << EOF > $file
USE mysql;
FLUSH PRIVILEGES;
UPDATE user SET Host="%" where Host="localhost" AND User="root";
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

DROP DATABASE test;

EOF

/usr/bin/mysqld --bootstrap --verbose=0 < $file
rm -f $file

chown -R mysql:mysql /var/lib/mysql
exec /usr/bin/mysqld_safe