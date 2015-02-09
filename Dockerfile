FROM ubuntu:14.04

MAINTAINER Philip Bower <pabower@gmail.com>

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# No tty
ENV DEBIAN_FRONTEND noninteractive

# Updates
RUN apt-get update
RUN apt-get install -y nginx php5-fpm php5-cli php5-mcrypt git

# Make updates to php.ini
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini

# Enable mcrypt / restart fpm
RUN php5enmod mcrypt
RUN service php5-fpm restart

ADD ./default /etc/nginx/sites-available/default

# Make laravel structure
RUN mkdir -p /var/www/laravel

# Restart nginx
RUN service nginx restart

# Swap file replace 1G with 2xRAM
#fallocate -l 1G /swapfile
#mkswap /swapfile
#swapon /swapfile

#cd ~
#curl -sS https://getcomposer.org/installer | php
#mv composer.phar /usr/local/bin/composer
#composer create-project laravel/laravel /var/www/laravel --prefer-dist
#chown -R :www-data /var/www/laravel
#chmod -R 775 /var/www/laravel/storage