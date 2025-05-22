FROM debian:bullseye

# 1. Installer les dépendances système
RUN apt-get update && apt-get install -y \
    gnupg apt-transport-https curl ca-certificates \
    autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev \
    libgnutls28-dev libmp3lame-dev libtool libvorbis-dev libxcb1-dev \
    libxcb-shm0-dev libxcb-xfixes0-dev meson ninja-build pkg-config texinfo \
    wget yasm zlib1g-dev nasm libx264-dev libx265-dev libnuma-dev \
    && apt-get clean

# 2. Télécharger et compiler FFmpeg 4.4
RUN cd /tmp && \
    git clone --branch n4.4 https://git.ffmpeg.org/ffmpeg.git ffmpeg && \
    cd ffmpeg && \
    ./configure --prefix=/usr --enable-gpl --enable-nonfree \
        --enable-libx264 --enable-libx265 && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf ffmpeg

# 3. Ajouter la clé GPG Jellyfin
RUN curl -fsSL https://repo.jellyfin.org/debian/jellyfin_team.gpg.key \
    | gpg --dearmor -o /usr/share/keyrings/jellyfin-archive-keyring.gpg

# 4. Ajouter le dépôt Jellyfin
RUN echo "deb [signed-by=/usr/share/keyrings/jellyfin-archive-keyring.gpg] https://repo.jellyfin.org/debian bullseye main" \
    > /etc/apt/sources.list.d/jellyfin.list

# 5. Installer Jellyfin serveur et interface web
RUN apt-get update && apt-get install -y \
    jellyfin-server \
    jellyfin-web \
    && apt-get clean

# 6. Correction du chemin de l’interface web si nécessaire
RUN ln -s /usr/share/jellyfin/web /usr/lib/jellyfin/bin/jellyfin-web || true

# 7. Préparer les dossiers pour volumes
RUN mkdir -p /config /media

# 8. Exposer le port de Jellyfin
EXPOSE 8096

COPY jellyfin-config.tar.gz /tmp/
RUN mkdir -p /config && \
    tar xzf /tmp/jellyfin-config.tar.gz -C /config

# 9. Lancer Jellyfin
CMD ["/usr/bin/jellyfin", "--datadir", "/config", "--cachedir", "/config"]
