FROM debian:bullseye

RUN apt update && apt install -y apache2

COPY html/ /var/www/html

RUN sed -i 's/80/6060/g' /etc/apache2/ports.conf \
 && sed -i 's/80/6060/g' /etc/apache2/sites-available/000-default.conf

EXPOSE 6060

CMD ["apachectl", "-D", "FOREGROUND"]
