# Inception

*This project has been created as part of the 42 curriculum by naankour.*

## Table of Contents
- [Description](#description)
- [Instructions](#instructions)
- [Resources](#resources)
- [Project Description](#docker-deep-dive)

---

## Description

### Project Overview

**Inception** is a Docker-based infrastructure project that sets up a complete web server environment. The project aims to deepen understanding of containerization, networking, and orchestration through practical implementation using Docker and Docker Compose.

### Goal

The objective is to build and manage a containerized application stack composed of three interconnected services:
- **NGINX**: A reverse proxy server handling HTTPS connections and SSL/TLS certificates
- **WordPress**: A PHP-based CMS for content management
- **MariaDB**: A relational database management system storing all application data

### Architecture Overview

The project demonstrates:
- Multi-container application orchestration
- Service networking and inter-service communication
- Volume management for data persistence
- Environment variable configuration
- Docker image building with Dockerfiles
- SSL/TLS certificate management

---

## Instructions

### Prerequisites

- Docker Engine (version 20.10 or higher)
- Docker Compose (version 1.29 or higher)
- Linux/Unix-based OS (the project uses `sudo` and Linux-specific paths)
- `make` utility

### Installation & Setup

#### 1. Configuration

Before running the project, create a `.env` file in the `srcs/` directory with the required environment variables:

```bash
cd srcs/
touch .env
```

Add the following variables:

```env
# MariaDB
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=your_wordpress_password

# WordPress
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@example.com
WP_TITLE=My Inception Site
DOMAIN_NAME=localhost
```

#### 2. Create Data Directories

The Dockerfile requires persistent storage directories:

### Execution Commands

#### Start the Services
```bash
make all
```
- Brings up all services defined in docker-compose.yml
- Access the application at `https://naankour.42.fr`

#### Build and Start
```bash
make build
```
- Creates data directories
- Builds all images from scratch
- Starts containers

#### Stop Services
```bash
make down
```
- Stops all running containers
- Does not remove volumes (data persists)

#### Clean Everything (Keep Volumes)
```bash
make clean
```
- Stops and removes containers
- Removes networks
- Removes data volumes

#### Full Reset (Remove All Data)
```bash
make fclean
```
- Performs complete cleanup
- **Deletes all persistent data** in `wp_data` and `mariadb_data`
- Recreates empty data directories for future use

#### Rebuild Everything
```bash
make re
```
- Equivalent to `make fclean build`
- Complete reset and rebuild

### Verification

Once services are running:

1. **Check containers**:
   ```bash
   docker ps
   ```

2. **Access WordPress**:
   - Open browser to `https://naankour.42.fr`
   - Accept self-signed certificate warning

3. **Test MariaDB connection**:
   ```bash
   docker exec -it <mariadb-container-id> bash
   mysql -u root -p<MYSQL_ROOT_PASSWORD>
   SHOW DATABASES;
   ```

4. **View logs**:
   ```bash
   docker logs <container-id>
   # or for all services
   cd srcs && docker compose logs
   ```

### Project Structure

```
Inception/
├── Makefile                          # Build automation
├── README.md                         # This file
└── srcs/
    ├── docker-compose.yml            # Service orchestration
    ├── .env                          # Environment variables
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile            # MariaDB image definition
        │   └── conf/
        │       ├── my.cnf            # MySQL configuration
        │       └── setup.sh          # Initialization script
        ├── nginx/
        │   ├── Dockerfile            # NGINX image definition
        │   └── conf/
        │       └── nginx.conf        # NGINX configuration
        └── wordpress/
            ├── Dockerfile            # WordPress image definition
            └── conf/
                └── setup.sh          # WordPress initialization script
```

---

## Resources

### Documentation & References

1. **Docker Official Documentation**
   - [Docker Docs](https://docs.docker.com/)
   - [Docker Compose Documentation](https://docs.docker.com/compose/)
   - [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
   - [Docker Compose Youtube](https://youtu.be/HUpIoF_conA?si=n_b1gPMur8rZJaal)

2. **Container Networking**
   - [Docker Networking Guide](https://docs.docker.com/network/)

3. **WordPress & PHP**
   - [WordPress Official Documentation](https://wordpress.org/support/)
   - [PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)

4. **NGINX & SSL/TLS**
   - [NGINX Documentation](https://nginx.org/en/docs/)
   - [Let's Encrypt & SSL Certificates](https://letsencrypt.org/docs/)
   - [Self-Signed Certificates Guide](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-18-04)

5. **MariaDB**
   - [MariaDB Documentation](https://mariadb.com/docs/)

### AI Usage

**AI was utilized for the following aspects of this project:**

- **Code Review & Optimization**: AI assisted in reviewing Dockerfile configurations and docker-compose.yml for best practices and potential improvements
- **Documentation**: Generation of comprehensive README sections and inline comments explaining complex configurations
- **Learning Support**: Assistance in understanding and learning new languages and technologies during the project.

---

## Project Descrption

### Understanding Docker in This Project

Docker allows packaging application services with dependencies into isolated containers. In Inception, it manages three interconnected services: NGINX, WordPress, and MariaDB.

#### How Docker & Docker Compose Work

**Docker Image (Blueprint):**
- Contains application code, libraries, and configuration
- Built from Dockerfile instructions
- Reusable across any system

**Docker Container (Instance):**
- Running instance of an image
- Isolated environment with own filesystem, processes, networking

**Docker Compose:**
- Orchestrates multiple containers as a single application
- Starts services in dependency order (`depends_on`)
- Provides automatic service discovery by name (e.g., `mariadb:3306`)

**Service Dependency in Inception:**
```
mariadb (base)
  ↓
wordpress (depends_on: mariadb)
  ↓
nginx (depends_on: wordpress)
```

---

### Virtual Machines vs Docker

A VM virtualizes an entire operating system with its own kernel, while Docker containers share the host OS kernel and only isolate the application environment.

VMs are heavier but more isolated, whereas Docker is faster, lighter, and more efficient for deploying applications.

**For Inception:** Docker provides lightweight, fast development cycles with consistent environments across teams—perfect for multi-service applications.

---

### Secrets vs Environment Variables

Environment variables (like those in a .env file) are plain text values used to configure an application, but they are not secure because they can be easily read or exposed.

Secrets are sensitive data (like passwords or API keys) stored and managed securely, often encrypted or protected from direct exposure.

**Why Inception uses env variables:** Development/learning, non-sensitive data. Production would use Docker Secrets.

---

### Docker Network vs Host Network

A Docker network is a virtual, isolated network created by Docker that allows containers to communicate with each other securely and independently from the host system. Containers on the same Docker network can easily interact using internal DNS and private IP addresses.

Host network mode removes this isolation and connects the container directly to the host machine’s network. This provides better performance but reduces security and flexibility. It is generally used when direct access to the host network is required.

**Why Inception uses bridge network:** Isolation, service discovery, security, multi-container coordination.

---

### Docker Volumes vs Bind Mounts

Docker provides two main ways to persist data outside containers: volumes and bind mounts.

Docker Volumes are managed by Docker and stored internally on the host system. They are easier to manage, more portable, and recommended for most use cases because Docker handles permissions and storage automatically.

Bind Mounts directly map a folder from the host machine into the container. This makes the data fully visible and accessible on the host, but requires manual management of paths and permissions.

In the Inception project, a hybrid approach is used: Docker volumes configured with driver_opts to behave like bind mounts. This means data is stored in specific host directories (e.g. /home/naankour/data) while still being managed through Docker’s volume system.

**Why This:** 
- Gets persistence of volumes (managed by Docker)
- Gets visibility of bind mounts (direct host access for debugging)
- Data in specific host directory can be backed up/deleted selectively with `make fclean`

---
