#!/bin/sh
set -e

: "${SQL_DATABASE:?Variable SQL_DATABASE manquante}"
: "${SQL_USER:?Variable SQL_USER manquante}"
: "${SQL_PASSWORD:?Variable SQL_PASSWORD manquante}"
: "${SQL_ROOT_PASSWORD:?Variable SQL_ROOT_PASSWORD manquante}"

# 1) Prépare le datadir
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "📦 Datadir vide : initialisation…"
  chown -R mysql:mysql /var/lib/mysql
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

# 2) Prépare le dossier pour le socket
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# 3) Démarre MariaDB
mysqld_safe --datadir=/var/lib/mysql &
pid="$!"

echo "⏳ Attente du démarrage de MariaDB…"
until mysqladmin ping --silent; do sleep 1; done
echo "✅ MariaDB prêt"

# 4) Initialisation uniquement si la BDD n'existe pas encore
if [ ! -d /var/lib/mysql/${SQL_DATABASE} ]; then
  echo "🔧 Configuration initiale…"

  mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`
      CHARACTER SET utf8
      COLLATE utf8_general_ci;

    CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';

    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

  # 5) Sauvegarde credentials root
  cat > /root/.my.cnf <<EOF
[client]
user=root
password=${SQL_ROOT_PASSWORD}
EOF
  chmod 600 /root/.my.cnf

  echo "✅ Base et utilisateur créés"
else
  echo "🟡 Base déjà initialisée, rien à faire"
fi

# 6) Garde MariaDB au premier plan
wait "$pid"
