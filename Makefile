COMPOSE = docker compose -f srcs/docker-compose.yml

.PHONY: all up down clean fclean re

all: up

up:
	@$(COMPOSE) up --build -d

nocache:
	@$(COMPOSE) build --no-cache
	@$(COMPOSE) up --build -d


down:
	@$(COMPOSE) down

clean:
	@$(COMPOSE) down -v

fclean: clean

reset: down
	sudo rm -rf /home/kasingh/data/mariadb
	sudo rm -rf /home/kasingh/data/wordpress
	sudo rm -rf /home/kasingh/data/jellyfin
	mkdir -p /home/kasingh/data/mariadb
	mkdir -p /home/kasingh/data/wordpress
	mkdir -p /home/kasingh/data/jellyfin/config
	mkdir -p /home/kasingh/data/jellyfin/media
	sudo chown -R 999:999 /home/kasingh/data/mariadb
	sudo chown -R www-data:www-data /home/kasingh/data/wordpress
	sudo chown -R 1000:1000 /home/kasingh/data/jellyfin
	docker volume rm srcs_mariadb_data srcs_wordpress_data srcs_jellyfin_config srcs_jellyfin_media || true
	docker image rm srcs-mariadb srcs-wordpress srcs-nginx srcs-adminer srcs-redis srcs-ftp srcs-jellyfin srcs-static_site || true
	docker network rm srcs_inception || true
	echo "Projet Inception reset."

re: fclean all

.PHONY: up down reset 