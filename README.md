*This project has been created as part of the 42 curriculum by naankour.*

## Description

**Inception** is a Docker containerization project implementing a complete web infrastructure with WordPress, MariaDB, and Nginx reverse proxy with SSL/TLS encryption. The project demonstrates multi-container orchestration, networking, and persistent storage management using Docker Compose.

**Services:**
- **Nginx** - Reverse proxy handling HTTPS (port 443) with SSL/TLS
- **WordPress** - PHP-based CMS
- **MariaDB** - Relational database

---

## Instructions

### Requirements
- Linux OS (Ubuntu 22.04+)
- Docker & Docker Compose installed
- `sudo` privileges
- 2GB+ disk space

### Setup

1. **Create data directories:**
   ```bash
   sudo mkdir -p /home/naankour/data/wp_data
   sudo mkdir -p /home/naankour/data/mariadb_data
   ```

2. **Configure `.env` file** in `srcs/`:
   ```
   MYSQL_ROOT_PASSWORD=naankour12
   MYSQL_DATABASE=wordpress
   MYSQL_USER=wordpress_user
   MYSQL_PASSWORD=wordpress_pass
   ```

### Execution

```bash
make build           # Build and start containers
make all             # Start containers
make down            # Stop containers
make clean           # Stop and remove volumes
make fclean          # Full cleanup (remove all data)
make re              # Clean rebuild
```

**Quick start:**
```bash
make build
# Access WordPress at https://localhost
```

---

## Technical Architecture

### Docker & Docker Compose

The project uses Docker Compose for multi-container orchestration with three services managed through a custom network. Services automatically restart on failure, and configuration is externalized via `.env` for security.

### Virtual Machines vs Docker

| Aspect | VM | Docker |
|--------|----|----|
| **Isolation** | Full OS | Process-level |
| **Overhead** | High (1-2GB each) | Low (few MB) |
| **Startup** | Minutes | Seconds |
| **Performance** | Hypervisor overhead | Near-native |

**Choice:** Docker provides lightweight containerization with fast deployment and excellent portability.

### Secrets vs Environment Variables

| Aspect | Env Variables | Docker Secrets |
|--------|---|---|
| **Security** | Visible in `docker inspect` | Encrypted |
| **Storage** | `.env` file | Docker daemon |
| **Use Case** | Development | Production |

**Choice:** `.env` used for development setup; production would use Docker Secrets.

### Docker Network vs Host Network

| Aspect | Docker Network | Host Network |
|--------|---|---|
| **Isolation** | Isolated namespace | Shared with host |
| **Discovery** | DNS resolution | Localhost only |
| **Security** | Better isolation | None |

**Choice:** Custom `inception_network` for service isolation and discovery.

### Docker Volumes vs Bind Mounts

| Aspect | Volumes | Bind Mounts |
|--------|---|---|
| **Management** | Docker-managed | Host-managed |
| **Portability** | High | Low |
| **Performance** | Optimized | Variable |

**Choice:** Named volumes with bind mounts for hybrid approach (Docker convenience + host visibility).

---

## Resources

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [MariaDB KB](https://mariadb.com/kb/en/)
- [WordPress Docs](https://wordpress.org/documentation/)

### AI Usage

AI was used for:
- **Documentation & structure** - Comprehensive README following 42 standards
- **Docker best practices** - Configuration optimization and orchestration patterns
- **Content formatting** - Professional organization and technical comparisons

Core application code and Dockerfiles were written by developers.

---

## Author

**naankour** - 42 School

---

## License

Educational project - 42 curriculum
