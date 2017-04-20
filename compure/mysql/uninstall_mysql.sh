#!/bin/sh
basedir=/usr/local/mysql         #MySQL安装路径datadir=/data/mysqldata       #MySQL数据路径
##stop service mysqldservice mysqld stopsleep 2
##delete my.cnfrm -rf $basedir/my.cnf
##delete service mysqldrm -rf /etc/init.d/mysqld
##delete user mysql and group mysqluserdel -r mysql
##delete mysql path of profile sed -i '/export PATH=/s#'$basedir'/bin:##g' /etc/profilesource /etc/profile
##delete basedir and datadirrm -rf $basedirrm -rf $datadir
echo "--------------uninstall MySQL completely------------"
