#!/bin/bash

set -eo pipefail

release=$(lsb_release -cs)
version=$1

# Suppression to startup failure
if [ -f /lib/systemd/system/php${version}-fpm.service ]
then
    sudo systemctl disable php${version}-fpm
fi

sudo add-apt-repository ppa:ondrej/php

if [ $version = '5.6' ]
then
    sudo apt-fast install -y build-essential debconf-utils unzip autogen autoconf libtool pkg-config

    sudo apt-fast install -y \
         php${version}-bcmath \
         php${version}-bz2 \
         php${version}-cgi \
         php${version}-cli \
         php${version}-common \
         php${version}-curl \
         php${version}-dba \
         php${version}-enchant \
         php${version}-gd \
         php${version}-json \
         php${version}-mbstring \
         php${version}-mysql \
         php${version}-odbc \
         php${version}-opcache \
         php${version}-pgsql \
         php${version}-readline \
         php${version}-soap \
         php${version}-sqlite3 \
         php${version}-xml \
         php${version}-xmlrpc \
         php${version}-xsl \
         php${version}-zip
fi

sudo apt-fast install -y \
     php${version}-dev \
     php${version}-phpdbg \
     php${version}-intl

sudo update-alternatives --set php /usr/bin/php${version}
sudo update-alternatives --set phar /usr/bin/phar${version}
sudo update-alternatives --set phpdbg /usr/bin/phpdbg${version}
sudo phpdismod -s cli xdebug

sudo bash -c 'echo "opcache.enable_cli=1" >> /etc/php/'$version'/cli/conf.d/10-opcache.ini'
sudo bash -c 'echo "apc.enable_cli=1" >> /etc/php/'$version'/cli/conf.d/20-apcu.ini'
