# Inception — Developer Documentation

## Prerequisites

- A VM running Ubuntu
- Docker Engine ≥ 20.10
- Docker Compose V2
- Linux/Unix OS
- `make`

Install dependencies on Ubuntu:
```bash
sudo apt update
sudo apt install -y docker.io docker-compose-v2 make
sudo usermod -aG docker $USER
# Log out and back in after this
```

---

## Project Structure

```
Inception/
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       └── nginx.conf
        ├── wordpress/
        │   ├── Dockerfile
        │   └── conf/
        │       └── setup.sh
        └── mariadb/
            ├── Dockerfile
            └── conf/
                ├── my.cnf
                └── setup.sh
```

---

## Environment Setup

### 1. Add domain to /etc/hosts

```bash
echo "127.0.0.1 naankour.42.fr" | sudo tee -a /etc/hosts
```

### 2. Configure the .env file

Create `srcs/.env` with the following variables:

```bash
# Domain
DOMAIN_NAME=naankour.42.fr

# MariaDB
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=your_db_user
MYSQL_PASSWORD=your_db_password

# WordPress
WP_TITLE=Inception
WP_ADMIN_USER=your_admin_user
WP_ADMIN_PASSWORD=your_admin_password
WP_ADMIN_EMAIL=your@email.com
WP_USER=your_second_user
WP_USER_PASSWORD=your_second_password
WP_USER_EMAIL=second@email.com
```

> ⚠️ Never commit `.env` to git — add it to `.gitignore`

---

## Build & Launch

```bash
make build  # creates data dirs, builds images, starts containers
make down   # stops containers
make re     # full stop + rebuild
make clean  # stops + removes all Docker images
make fclean # clean + wipes all persistent data
```

Under the hood, `make` runs:
```bash
mkdir -p /home/naankour/data/wp_data
mkdir -p /home/naankour/data/mariadb_data
docker compose -f srcs/docker-compose.yml up --build
```

---

## Container Management

**List running containers:**
```bash
docker ps
```

**View logs:**
```bash
docker logs srcs-nginx-1
docker logs srcs-wordpress-1
docker logs srcs-mariadb-1
```

**Enter a container:**
```bash
docker exec -it srcs-nginx-1 bash
docker exec -it srcs-wordpress-1 bash
docker exec -it srcs-mariadb-1 bash
```

**Rebuild a single service:**
```bash
docker compose -f srcs/docker-compose.yml up --build nginx
docker compose -f srcs/docker-compose.yml up --build wordpress
docker compose -f srcs/docker-compose.yml up --build mariadb
```
---

## Data Persistence

Data is stored on the host VM using bind mounts:

| Service | Host path | Container path |
|---|---|---|
| MariaDB | `/home/naankour/data/mariadb_data` | `/var/lib/mysql` |
| WordPress | `/home/naankour/data/wp_data` | `/var/www/html` |

Data **persists** across `make down` and `make re`.
Data is **wiped** only with `make fclean`.

**Check MariaDB data directly:**
```bash
docker exec -it srcs-mariadb-1 bash
mysql -u root -p$MYSQL_ROOT_PASSWORD
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
```

**Check WordPress files:**
```bash
ls /home/naankour/data/wp_data
```

---

## Network

All containers communicate through a single Docker bridge network: `inception_network`.

| Service | Internal address | Port |
|---|---|---|
| NGINX | `nginx` | 443 |
| WordPress | `wordpress` | 9000 |
| MariaDB | `mariadb` | 3306 |

NGINX is the only container exposed to the host (port 443).
WordPress and MariaDB are only reachable internally.

---

## SSL Certificate

The SSL certificate is self-signed and generated at build time inside the NGINX Dockerfile:

```bash
openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Nice/L=Nice/O=42/CN=naankour.42.fr"
```

Stored at `/etc/nginx/ssl/` inside the NGINX container.
TLS 1.2 and 1.3 only — older versions are disabled by the subject requirements.
