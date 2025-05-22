FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server vim zsh && \
    mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld        # ← donne l’accès au serveur

# On laisse MariaDB utiliser son chemin **par défaut** pour éviter les confusions
# (socket = /var/run/mysqld/mysqld.sock).  Donc supprimez la ligne `socket = …`
# de votre 50-server.cnf, ou mettez-la à /var/run/…

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Lancer directement mysqld en premier-plan : plus simple et fait pour Docker
ENTRYPOINT ["/init.sh"]
