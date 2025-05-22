#!/bin/bash
set -e

WP_PATH=/var/www/wordpress

if [ ! -f "${WP_PATH}/wp-config.php" ]; then
  echo "Téléchargement de WordPress…"
  if ! wp core download --path=${WP_PATH} --allow-root; then
      echo "❗ 1ᵉʳ essai échoué, on recommence en --insecure"
      rm -rf ${WP_PATH:?}/*                
      wp core download --path=${WP_PATH} --allow-root --insecure
  fi

  echo "Création du wp-config…"
  wp config create \
       --dbname=$SQL_DATABASE \
       --dbuser=$SQL_USER \
       --dbpass=$SQL_PASSWORD \
       --dbhost=mariadb:3306 \
       --path=${WP_PATH} --allow-root

  echo "Installation de WordPress…"
  wp core install \
       --url=$DOMAIN_NAME \
       --title="$TITLE" \
       --admin_user=$WP_ADMIN_USER \
       --admin_password=$WP_ADMIN_PASSWORD \
       --admin_email=$WP_ADMIN_EMAIL \
       --path=${WP_PATH} --allow-root

  echo "Création de l’utilisateur standard…"
  wp user create $WP_USER $WP_USER_EMAIL \
       --user_pass=$WP_USER_PASSWORD \
       --role=author \
       --path=${WP_PATH} --allow-root
  echo "Configuration Redis pour le cache"
  echo "define(''WP_REDIS_HOST', 'redis');" >> ${WP_PATH}/wp-config.php
  
  echo "Installation et activation du plugin Redis Object Cache…"
  wp plugin install redis-cache --activate --path=${WP_PATH} --allow-root

  echo "Activation automatique du cache Redis…"
  wp redis enable --path=${WP_PATH} --allow-root
fi

sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

echo "Démarrage de PHP-FPM…"
mkdir -p /run/php
chown www-data:www-data /run/php
exec php-fpm7.4 -F