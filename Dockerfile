#FROM php:8.1-fpm-alpine

# Install extension
#RUN docker-php-ext-install pdo pdo_mysql
# Install Composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

FROM php:8.1-apache
LABEL maintainer="manhvt"

# Install extension
RUN docker-php-ext-install pdo pdo_mysql mysqli bcmath intl gd zip

# install git, nodejs, npm
RUN  apt-get update && apt-get install -y ca-certificates gnupg
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get upgrade -y && apt-get install -y git nodejs npm

#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
#RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#RUN /usr/sbin/a2enmod rewrite && /usr/sbin/a2enmod headers && /usr/sbin/a2enmod expires
#RUN apt-get update && apt-get install -y libzip-dev zip && docker-php-ext-install zip
#RUN docker-php-ext-install pdo pdo_mysql mysqli
#RUN apt-get install -y libtidy-dev && docker-php-ext-install tidy && docker-php-ext-enable tidy
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN pecl install xdebug && docker-php-ext-enable xdebug
#RUN echo 'zend_extension=xdebug' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.mode=develop,debug' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/php.ini
#RUN echo 'session.save_path = "/tmp"' >> /usr/local/etc/php/php.ini
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libicu-dev \
    libgd-dev \
    openssl \
    nano

RUN a2enmod rewrite headers

RUN echo "date.timezone = \"\${PHP_TIMEZONE}\"" > /usr/local/etc/php/conf.d/timezone.ini

WORKDIR /app
COPY ./src /app
RUN ln -s /app/*[^public] /var/www && rm -rf /var/www/html && ln -nsf /app/public /var/www/html
#RUN chmod -R 750 /app/storage /app/storage/logs && chown -R www-data:www-data /app/public /app/app


##FROM ospos AS ospos_test

##COPY --from=composer /usr/bin/composer /usr/bin/composer

##RUN apt-get install -y libzip-dev wget git
##RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /bin/wait-for-it.sh && chmod +x /bin/wait-for-it.sh
##RUN docker-php-ext-install zip
##RUN composer install -d/app 
##RUN php /app/vendor/kenjis/ci-phpunit-test/install.php -a /app/application -p /app/vendor/codeigniter/framework
##RUN sed -i 's/backupGlobals="true"/backupGlobals="false"/g' /app/application/tests/phpunit.xml
##RUN sed -i '13,17d' /app/application/tests/controllers/Welcome_test.php 
##WORKDIR /app/application/tests

##CMD ["/app/vendor/phpunit/phpunit/phpunit"]

#FROM mike AS php-laravel

#RUN mkdir -p /app/bower_components && ln -s /app/bower_components /var/www/html/bower_components
#RUN yes | pecl install xdebug \
#    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini
