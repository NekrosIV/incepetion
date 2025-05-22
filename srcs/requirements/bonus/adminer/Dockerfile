FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php \
    php-mysql \
    libapache2-mod-php \
    apache2 \
    wget

RUN a2enmod php7.4

RUN mkdir -p /var/www/html && \
    wget -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

RUN chown -R www-data:www-data /var/www/html

RUN rm -f  /var/www/html/index.html

RUN chmod 644 /var/www/html/index.php && \
    chown www-data:www-data /var/www/html/index.php

RUN sed -i 's/DirectoryIndex .*/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf

RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf && \
    sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf

COPY conf/set_domain.sh /set_domain.sh
RUN chmod +x /set_domain.sh

EXPOSE 8080


ENTRYPOINT ["/set_domain.sh"]
