#!/bin/bash
#TODO 
#check if sestatus disabled
#add iptables
#create keys for tls SRTP
#firewalld not removed
MYSQL_PWD=$(openssl rand -base64 16)
MYSQL_USER=root
echo $MYSQL_PWD > mysqlpass
# Opening TCP port 80 fro administration interface access
#
yum remove firewalld -y
systemctl disable firewalld
# Updating packages
yum -y update

# Installing needed tools and packages
yum -y groupinstall core base "Development Tools"

#Installing additional required dependencies
yum -y install lynx tftp-server unixODBC mysql-connector-odbc mariadb-server mariadb httpd ncurses-devel sendmail sendmail-cf sox newt-devel libxml2-devel libtiff-devel audiofile-devel gtk2-devel subversion kernel-devel git crontabs cronie cronie-anacron wget vim uuid-devel sqlite-devel net-tools gnutls-devel python-devel texinfo

#Installing php 5.6 repositories
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

wget https://mirror.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7
rpm --import RPM-GPG-KEY-webtatic-el7
# Install php5.6w
yum install php56w php56w-pdo php56w-mysql php56w-mbstring php56w-pear php56w-process php56w-xml php56w-opcache php56w-ldap php56w-intl php56w-soap -y

#Installing nodejs
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nodejs

# Enabling and starting MariaDB
systemctl enable mariadb.service
systemctl start mariadb

mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "UPDATE mysql.user SET Password=PASSWORD('${MYSQL_PWD}') WHERE User='root';"
mysql -e "FLUSH PRIVILEGES;"

# Enabling and starting Apache
systemctl enable httpd.service
systemctl start httpd.service

# Installing Legacy Pear requirements
pear install Console_Getopt

#Installing Dependencies for Google Voice if needed
#Installing iksemel


# Compiling and Installing jansson
cd /usr/src
wget -O jansson.zip https://codeload.github.com/akheron/jansson/zip/master
unzip jansson.zip
rm -f jansson.zip
cd jansson-*
autoreconf -i
./configure --libdir=/usr/lib64
make
make install

#Compile and install DAHDI if needed
#If you don't have any physical PSTN hardware attached to this machine, you don't need to install DAHDI (For example, a T1 or E1 card, or a USB device). Most smaller setups will not have DAHDI hardware, and this step can be safely skipped.


# Preparing for Asterisk installation
adduser asterisk -m -c "Asterisk User"

# Downloading Asterisk source files.
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz
wget http://downloads.digium.com/pub/telephony/codec_g729/asterisk-14.0/x86-64/codec_g729a-14.0_current-x86_64.tar.gz
wget http://downloads.digium.com/pub/telephony/codec_opus/asterisk-14.0/x86-64/codec_opus-14.0_current-x86_64.tar.gz
wget http://downloads.digium.com/pub/telephony/codec_silk/asterisk-14.0/x86-64/codec_silk-14.0_current-x86_64.tar.gz
wget http://downloads.digium.com/pub/telephony/codec_siren7/asterisk-14.0/x86-64/codec_siren7-14.0_current-x86_64.tar.gz
wget http://downloads.digium.com/pub/telephony/codec_siren14/asterisk-14.0/x86-64/codec_siren14-14.0_current-x86_64.tar.gz
wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-14.0-latest.tgz
ls -1 | while read line ; do tar xvfz $line ; done
rm -rf $(ls  *tar.gz*)
# Compiling and installing Asterisk
cd /usr/src


cd asterisk-*
contrib/scripts/install_prereq install
./configure --libdir=/usr/lib64 --with-crypto --with-ssl=ssl --with-srtp --with-pjproject-bundled
contrib/scripts/get_mp3_source.sh

# Making some configuration of installation options, modules, etc. After selecting 'Save & Exit' you can then continue
cp -R menuselect* /usr/src/asterisk-*

# Installation itself
make
make install
make config
ldconfig
systemctl disable asterisk

# Setting Asterisk ownership permissions.
chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/{lib,log,spool}/asterisk
chown -R asterisk. /usr/lib64/asterisk
chown -R asterisk. /var/www/

# Preparing for FreePBX installation. A few small modifications to Apache and PHP.
sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php.ini
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
systemctl restart httpd.service

# Download and install FreePBX.
cd /usr/src/freepbx
./start_asterisk start
./install -n --dbuser=${MYSQL_USER} --dbpass ${MYSQL_PWD}