#!/bin/sh
set -e

# 0) Variables issues de .env
: "${SQL_DATABASE:?Variable SQL_DATABASE manquante}"
: "${SQL_USER:?Variable SQL_USER manquante}"
: "${SQL_PASSWORD:?Variable SQL_PASSWORD manquante}"
: "${SQL_ROOT_PASSWORD:?Variable SQL_ROOT_PASSWORD manquante}"

# 1) Init du datadir si nécessaire
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Datadir vide : initialisation…"
  chown -R mysql:mysql /var/lib/mysql
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

# 2) Prépare le socket
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# 3) Lance MariaDB en arrière-plan
mysqld_safe --datadir=/var/lib/mysql &
pid="$!"

echo "Attente du démarrage de MariaDB…"
until mysqladmin ping --silent; do sleep 1; done
echo "MariaDB prêt"

# 4) Configuration initiale (si base absente)
if ! mysql -e "USE \`${SQL_DATABASE}\`" 2>/dev/null; then
  echo "🔧 Configuration initiale…"

  mysql <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`
      CHARACTER SET utf8
      COLLATE utf8_general_ci;

    CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';

    -- mot de passe root
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

  echo "✅ Base et utilisateur créés"
fi

# 5) Enregistre le mot de passe root pour les futurs accès
cat > /root/.my.cnf <<EOF
[client]
user=root
password=${SQL_ROOT_PASSWORD}
EOF
chmod 600 /root/.my.cnf

# 6) Reste au premier plan
wait "${pid}"
