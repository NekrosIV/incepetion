COMPOSE = docker compose -f srcs/docker-compose.yml

.PHONY: all up down clean fclean re

all: up

up:
	@$(COMPOSE) up --build -d

down:
	@$(COMPOSE) down

clean:
	@$(COMPOSE) down -v

fclean: clean
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q 2>/dev/null | grep -v "bridge\|host\|none") || true

re: fclean all