docker compose https://youtu.be/HUpIoF_conA?si=hbohc3BrGhbailvZ

NGINX
reçoit la connexion HTTPS (443)
gère le certificat SSL
transmet la requête
WordPress
génère les pages (PHP)
MariaDB
stocke les données

pour tester mariadb:
docker compose down
sudo rm -rf /home/naankour/data/mariadb/*
docker compose up --build mariadb
docker ps
docker exec -it srcs-mariadb-1 bash
mysql -u root -pnaankour12
SHOW DATABASES;
SELECT User, Host FROM mysql.user;