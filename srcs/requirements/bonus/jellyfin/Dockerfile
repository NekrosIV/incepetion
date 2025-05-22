FROM debian:bullseye

RUN apt-get update && apt-get -y install \
    gnupg \
    apt-transport-https \
    curl \
    software-properties-common

RUN curl -fsSL https://repo.jellyfin.org/debian/jellyfin_team.gpg.key | gpg --dearmor -o /usr/share/keyrings/jellyfin-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/jellyfin-archive-keyring.gpg] https://repo.jellyfin.org/debian bullseye main" > /etc/apt/sources.list.d/jellyfin.list

RUN apt-get update && apt-get install -y jellyfin

RUN mkdir -p /config /media

EXPOSE 8096

CMD ["/usr/bin/jellyfin", "--datadir", "/config", "--cachedir", "/config"]