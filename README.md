# 🐳 Inception - 42 Project

This project is part of the 42 school curriculum.  
The goal is to set up a secure, functional web infrastructure using Docker and Docker Compose, without relying on pre-built images (except base OS).

---

## 🔧 What you will build

You must create a **Docker-based mini infrastructure** composed of:

- `NGINX` with **TLSv1.2 or TLSv1.3** (HTTPS only)
- `WordPress` with `php-fpm` (no NGINX)
- `MariaDB` (for database only, no NGINX)
- Docker **Volumes** for database and WordPress persistence
- A private **Docker network** to connect everything
- A `Makefile` to build and run the infrastructure easily

---

## 📁 Project structure (simplified)

```
inception/
├── Makefile
├── .env
├── docker-compose.yml
└── srcs/
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/setup.sh
        └── mariadb/
            ├── Dockerfile
            └── conf/
```

---

## 🚀 Useful Docker Commands

### Images & Containers

```bash
docker build -t <image_name> .          # Build a Docker image
docker run -it --name <container> bash  # Run a container with terminal
docker ps -a                             # List all containers
docker rm -f <container>                # Remove a container
docker image ls                         # List images
docker rmi <image>                      # Remove an image
```

### Volumes & Networks

```bash
docker volume ls                        # List volumes
docker volume rm <volume>              # Remove a volume
docker network ls                       # List networks
docker network rm <network>            # Remove a network
```

---

## ⚙️ Docker Compose

```bash
docker-compose up --build -d      # Build and run all containers in background
docker-compose down -v            # Stop and remove containers + volumes
docker-compose logs -f            # View live logs
docker-compose exec wordpress bash  # Open a shell inside the WordPress container
```
