#!/usr/bin/env bash

######################################################################
## BOTH FILES NEED Linux "Line endings" (LF)!                       ##
## You need to create a github_login.sh with the following content: ##
## name=github_login_name                                           ##
## pw=github_login_password                                         ##
######################################################################

source /vagrant/github_login.sh

#
# Add PHP and PostgreSQL and Nginx repositories
#
echo "--------------------> add repositories <--------------------";
add-apt-repository -y ppa:ondrej/php
apt-add-repository -y ppa:chris-lea/libsodium
add-apt-repository -y ppa:chris-lea/redis-server
touch /etc/apt/sources.list.d/pgdg.list
echo -e "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" | tee -a /etc/apt/sources.list.d/pgdg.list &>/dev/null
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo "deb http://nginx.org/packages/mainline/ubuntu/ `lsb_release -cs` nginx" >> /etc/apt/sources.list
echo "deb-src http://nginx.org/packages/mainline/ubuntu/ `lsb_release -cs` nginx"  >> /etc/apt/sources.list
curl http://nginx.org/keys/nginx_signing.key | apt-key add -

#
# Cleanup package manager
#
echo "--------------------> install clean up manager <--------------------";
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

sudo apt-key update
sudo apt-get update -qq
sudo apt-get upgrade -y --force-yes
sudo apt-get autoremove -y

#
# install basics
#
echo "--------------------> install basic packages <--------------------";
sudo apt-get install -y \
    curl \
    git \
    unzip \
    grc \
    gcc \
    make \
    re2c \
    libpcre3-dev \
    build-essential \
    software-properties-common \
    python-software-properties

#
# install php
#
echo "--------------------> install php <--------------------";
sudo apt-get install -y \
    php7.0 \
    php7.0-fpm \
    php7.0-cli \
    php7.0-curl \
    php7.0-gd \
    php7.0-intl \
    php7.0-zip \
    php7.0-pgsql \
    php7.0-dev
    php-xdebug

#
# install nginx, postgres, node.js, npm, bower
#
echo "--------------------> install nginx, postgres, node.js, npm, bower <--------------------";
sudo apt-get install -y \
    nginx \
    postgresql \
    postgresql-contrib
    nodejs
    npm

sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g bower

#
# install phalcon
#
echo "--------------------> install phalcon <--------------------";
curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
sudo apt-get install php7.0-phalcon

#
# Composer for PHP
#
echo "--------------------> install composer <--------------------";
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#
# copy configs
#
echo "--------------------> copy configs <--------------------";
sudo cp /vagrant/config/php/php.ini /etc/php/7.0/fpm/php.ini
sudo cp /vagrant/config/php/cli_php.ini /etc/php/7.0/cli/php.ini
sudo cp /vagrant/config/php/www.conf /etc/php/7.0/fpm/pool.d/www.conf
sudo cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp /vagrant/config/nginx/default.conf /etc/nginx/conf.d/default.conf
sudo cp /vagrant/config/pgsql/postgresql.conf /etc/postgresql/9.6/main/postgresql.conf
sudo cp /vagrant/config/pgsql/pg_hba.conf /etc/postgresql/9.6/main/pg_hba.conf

#
# restart services
#
echo "--------------------> restart services <--------------------";
sudo service postgresql restart
sudo service php7.0-fpm restart
sudo service nginx restart

#
# load repository
#
echo "--------------------> load repository <--------------------";

cd /var/www
git clone https://${name}:${pw}@${giturl}
cd woh/
composer install
ln -s /var/www/woh/vendor/phalcon/devtools/phalcon.php /usr/bin/phalcon
chmod ugo+x /usr/bin/phalcon
bower install
