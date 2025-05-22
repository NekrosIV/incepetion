FROM debian:bullseye

RUN apt update && apt install -y apache2

COPY html/ /var/www/html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
