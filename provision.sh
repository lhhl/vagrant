#
# setting proxy
#
# ping -c1 -W1 tci-proxy.trans-cosmos.co.jp > /dev/null
# if [ $? == 0 ];then
#	export http_proxy=http://tci-proxy.trans-cosmos.co.jp:8080
#	export https_proxy=https://tci-proxy.trans-cosmos.co.jp:8080
# fi

#
# setting service
#
/sbin/service iptables stop
/sbin/chkconfig iptables off

#
# yum repository
#
ius=http://dl.iuscommunity.org/pub/ius/stable/CentOS/$(uname -r | sed 's/.*el//;s/\..*$//;s/[^0-9]//g')/$(uname -i)
curl -sL $ius | sed 's/.*\(\(epel\|ius\)-release.*rpm\).*/\1/p;d' | xargs -i rpm -Uvh $ius/{}

yum -y update
yum -y install yum-plugin-replace

#
# MySQL
#
if [ "`rpm -V mysql55-libs`" ];then
	yum -y install mysql
	yum -y replace mysql --replace-with mysql55
	yum -y install mysql55-server
fi
cp /vagrant/conf/mysql/my.cnf /etc/my.cnf
/sbin/service mysqld start
/sbin/chkconfig mysqld on
mysqladmin -u root create ggg --default-character-set=utf8

#
# php
#
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum install -y php56w php56w-opcache php56w-xml php56w-mcrypt php56w-gd php56w-devel php56w-mysql php56w-intl php56w-mbstring php56w-bcmath
touch /var/log/php.log && chmod 666 /var/log/php.log
cp /vagrant/conf/php/php.ini /etc/php.ini

#
# Xdebug
#
#cp /vagrant/conf/php/xdebug.ini /etc/php.d/

#
# Apache
#
yum -y install httpd httpd-tools cronolog
cp /vagrant/conf/apache/httpd.conf /etc/httpd/conf/
/sbin/service httpd start
/sbin/chkconfig httpd on

#
# Postfix
#
yum -y install postfix
cp /vagrant/conf/postfix/main.cf /etc/postfix/
cp /vagrant/conf/postfix/transport /etc/postfix/
postmap /etc/postfix/transport
/sbin/service postfix restart
/sbin/chkconfig postfix on

#
# Dovecot
#
yum -y install dovecot
cp /vagrant/conf/dovecot/10-mail.conf /etc/dovecot/conf.d/
/sbin/service dovecot start
/sbin/chkconfig dovecot on

# #
# # Beanstalkd
# #
# yum -y install beanstalkd
# yum -y install beanstalkd
# cp /vagrant/conf/beanstalkd/beanstalkd /etc/sysconfig/
# /sbin/service beanstalkd start
# /sbin/chkconfig beanstalkd on

# #
# # supervisor
# #
# yum -y install supervisor
# cp /vagrant/conf/supervisor/supervisor /etc/supervisord.conf
# /sbin/service supervisord start
# /sbin/chkconfig supervisord on

# #
# # Redis
# #
# yum -y install redis
# /sbin/service redis start
# /sbin/chkconfig redis on

#
# Composer
#
cd /var/tmp/
curl -s http://getcomposer.org/installer | php
mv ./composer.phar /usr/local/bin/composer

#
# etc
#
yum -y install vim
yum -y install screen
yum -y install man
yum -y install man-pages-ja
yum -y install bind-utils
yum -y install git
cp /vagrant/conf/home/.bash_profile /home/vagrant/
