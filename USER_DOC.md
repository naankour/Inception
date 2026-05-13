# Inception — User Documentation

## What is this project?

Inception is a containerized web server stack running three services:

| Service | Role |
|---|---|
| **NGINX** | Reverse proxy, handles HTTPS (port 443) |
| **WordPress** | Content management system |
| **MariaDB** | Database storing all WordPress data |

---

## Start & Stop

**Start the project:**
```bash
make build
```

**Stop the project:**
```bash
make down
```

**Full reset (removes all data):**
```bash
make fclean
```

**Rebuild everything from scratch:**
```bash
make re
```

---

## Access the website

1. Open your browser and go to: `https://naankour.42.fr`
2. Accept the self-signed certificate warning (click **Advanced → Continue**)
3. The WordPress site is now accessible

---

## Access the admin panel

1. Go to: `https://naankour.42.fr/wp-admin`
2. Log in with the admin credentials from `srcs/.env`:
   - **Username:** value of `WP_ADMIN_USER`
   - **Password:** value of `WP_ADMIN_PASSWORD`
3. You now have full access to the WordPress dashboard

---

## Credentials

All credentials are stored in `srcs/.env`.

| Variable | Description |
|---|---|
| `WP_ADMIN_USER` | WordPress admin username |
| `WP_ADMIN_PASSWORD` | WordPress admin password |
| `WP_USER` | WordPress secondary user |
| `WP_USER_PASSWORD` | Secondary user password |
| `MYSQL_USER` | Database username |
| `MYSQL_PASSWORD` | Database password |
| `MYSQL_ROOT_PASSWORD` | Database root password |

**To change a credential**, edit `srcs/.env`, then do a full rebuild:
```bash
make fclean
make build
```

---

## Check services are running

```bash
docker ps
```

You should see 3 containers with status **Up**:

```
srcs-nginx-1      → port 443
srcs-wordpress-1  → port 9000
srcs-mariadb-1    → port 3306
```

**View logs for a specific service:**
```bash
docker logs srcs-nginx-1
docker logs srcs-wordpress-1
docker logs srcs-mariadb-1
```

**Enter a container:**
```bash
docker exec -it srcs-mariadb-1 bash
docker exec -it srcs-wordpress-1 bash
```

**Check the database:**
```bash
docker exec -it srcs-mariadb-1 bash
mysql -u root -p
$MYSQL_ROOT_PASSWORD
SHOW DATABASES;
```
