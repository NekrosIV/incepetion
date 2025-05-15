FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        php php-fpm php-mysql \
        wget unzip curl mariadb-client vim

# installe WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# …

COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["setup.sh"]
