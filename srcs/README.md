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


How Docker and docker compose work
The difference between a Docker image used with docker compose and without docker compose
The benefit of Docker compared to VMs
The pertinence of the directory structure required for this project (an example is provided in the subject's PDF file).Ensure that docker-network is used by checking the docker-compose.yml file. Then run the 'docker network ls' command to verify that a network is visible.
The evaluated student has to give you a simple explanation of docker-network. If any of the above points is not correct, the evaluation process ends now.