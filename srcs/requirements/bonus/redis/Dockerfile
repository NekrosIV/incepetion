FROM debian:bullseye

RUN apt-get update && apt-get install -y redis-server

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no"]