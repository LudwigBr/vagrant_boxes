#!/usr/bin/env bash

#
# Add PHP and PostgreSQL and Nginx repositories
#
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
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

sudo apt-key update
sudo apt-get update -qq
sudo apt-get upgrade -y --force-yes
sudo apt-get autoremove -y

#
# install basics
#
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

#
# install nginx, postgres
#
sudo apt-get install -y \
    nginx \
    postgresql \
    postgresql-contrib

#
# install phalcon
#
git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd cphalcon/build
sudo ./install
sudo touch /etc/php/7.0/fpm/conf.d/30-phalcon.ini
sudo echo "extension=phalcon.so" > /etc/php/7.0/fpm/conf.d/30-phalcon.ini
sudo touch /etc/php/7.0/cli/conf.d/30-phalcon.ini
sudo echo "extension=phalcon.so" > /etc/php/7.0/cli/conf.d/30-phalcon.ini

#
# Composer for PHP
#
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#sudo git clone git://github.com/phalcon/phalcon-devtools.git
#cd phalcon-devtools
#. ./phalcon.sh

#
# copy configs
#
sudo cp /vagrant/config/php/php.ini /etc/php/7.0/fpm/php.ini
sudo cp /vagrant/config/php/www.conf /etc/php/7.0/fpm/pool.d/www.conf
sudo cp /vagrant/config/nginx/default.conf /etc/nginx/conf.d/default.conf

#
# restart services
#
sudo service php7.0-fpm restart
sudo service nginx restart
