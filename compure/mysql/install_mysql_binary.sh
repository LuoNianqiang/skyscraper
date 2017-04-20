#!/bin/sh
mysqlzip=mysql-5.6.32-linux-glibc2.5-x86_64.tar.gz  #安装包路径basedir=/usr/local/mysql         #MySQL安装路径datadir=/data/mysqldata       #MySQL数据路径cnfdir=$basedir/my.cnf                          #my.cnf文件路径sockdir=$datadir/mysql.sock                     #mysql.sock文件路径port=3306                         #端口instlog=/data/mysqlinstall.log      #安装日志路径         
echo "------------------MySQL install beginning----------------" > $instlog##create basedir and datadir if not exist  if [ ! -d $basedir ] then echo "creating $basedir......." >> $instlog  mkdir -p $basedirfi
if [ ! -d $datadir ] then echo "creating $datadir......." >> $instlog  mkdir -p $datadirfi
if [ ! -d $basedir -a ! -d $datadir ]then echo "$basedir or $datadir not exist, mysql install stop!" >> $instlog exitfi
##create group,usergroup=mysqluser=mysqlegrep "^$group" /etc/group >& /dev/nullif [ $? -ne 0 ]then echo "creating group $group....."  >> $instlog groupadd $groupelse echo "group $group existed"  >> $instlogfi
egrep "^$user" /etc/passwd >& /dev/nullif [ $? -ne 0 ]then echo "creating user $user set group $group ....." >> $instlog    useradd -g $group $userelse echo "user $user existed" >> $instlogfi
#setup datadir authority for the created group and userchown -R $group:$user $datadirecho "action (chown -R $group:$user $datadir) completed!" >> $instlog
#unzip mysql and do installtar xzvf $mysqlzip -C $basedirecho "action (tar xzvf $mysqlzip -C $basedir) completed!" >> $instlog
cd $basedirmv mysql*/* .scripts/mysql_install_db --basedir=$basedir --datadir=$datadir --user=mysql --defaults-file=$cnfdirecho "execute scripts mysql_install_db completed!" >> $instlog
pid=$(ps -ef | grep $port | sed -n '1p;1q' | awk '{print $2}')kill -9 $pidecho "mysql old process $pid killed........" >> $instlog
cp support-files/my-default.cnf  $cnfdirecho "establish my.cnf completed!" >> $instlog
echo "configuring my.cnf options........" >> $instlogecho "basedir = "$basedir >> $cnfdirecho "datadir = "$datadir >> $cnfdirecho "port = "$port >> $cnfdirecho "socket = "$sockdir >> $cnfdirecho "lower_case_table_names = 1" >> $cnfdirecho "event_scheduler = 1" >> $cnfdirecho "autocommit = 1" >> $cnfdirecho "read_buffer_size = 256M" >> $cnfdirecho "read_rnd_buffer_size = 256M" >> $cnfdirecho "sort_buffer_size = 256M" >> $cnfdirecho "join_buffer_size = 256M" >> $cnfdirecho "query_cache_size = 1G" >> $cnfdirecho "key_buffer_size = 2G" >> $cnfdirecho "innodb_buffer_pool_size = 10G" >> $cnfdirecho "innodb_thread_concurrency = 16" >> $cnfdir
echo "configuring environment variable........" >> $instlogsed  -i '/export PATH=/d' /etc/profileecho "export PATH="$basedir"/bin:$PATH" >> /etc/profilesource /etc/profile
echo "configuring mysqld service........" >> $instlogcp support-files/mysql.server  /etc/init.d/mysqldchmod +x  /etc/init.d/mysqld
echo "setup mysqld service auto-startup........" >> $instlogchkconfig --add mysqldchkconfig --level 345 mysqld on
echo "starting mysqld service........" >> $instlogservice mysqld start
echo "-------------MySQL installation was successful!---------------"  >> $instlog
