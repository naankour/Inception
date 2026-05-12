FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php-fpm\
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    wget \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html
RUN mkdir -p /run/php

WORKDIR /var/www/html

COPY conf/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

CMD ["/setup.sh"]


# FROM debian:bullseye
# → on part d'une Debian 11 vierge, comme pour MariaDB

# RUN apt-get update && apt-get install -y \
# → met à jour le catalogue et installe plusieurs paquets d'un coup. Le \ permet de continuer sur la ligne suivante pour plus de lisibilité
# php7.4-fpm → le moteur PHP qui va exécuter le code WordPress
# php7.4-mysql → permet à PHP de parler à MariaDB
# php7.4-curl → permet à PHP de faire des requêtes internet
# php7.4-gd → permet à PHP de manipuler les images
# php7.4-mbstring → gère les caractères spéciaux (accents, japonais, etc.)
# php7.4-xml → gère le XML, nécessaire pour WordPress
# php7.4-zip → permet d'installer des plugins WordPress en .zip
# wget → outil pour télécharger des fichiers depuis internet, on en a besoin pour télécharger wp-cli
# mariadb-client → permet d'utiliser mysqladmin dans le setup.sh pour vérifier que MariaDB est prêt
# rm -rf /var/lib/apt/lists/* → supprime le cache apt pour alléger l'image

# RUN wget https://...wp-cli.phar → télécharge wp-cli
# chmod +x wp-cli.phar → le rend exécutable
# mv wp-cli.phar /usr/local/bin/wp → le déplace pour pouvoir taper juste wp

# RUN mkdir -p /var/www/html → crée le dossier où WordPress sera installé
# RUN mkdir -p /run/php → crée le dossier nécessaire pour que PHP-FPM démarre (il y met son fichier socket)

# WORKDIR /var/www/html → définit le dossier de travail par défaut. Toutes les commandes suivantes s'exécutent depuis ce dossier

# COPY conf/wp-config.php /wp-config.php → copie ta config WordPress dans le conteneur à la racine
# COPY conf/setup.sh /setup.sh → copie ton script de démarrage
# RUN chmod +x /setup.sh → rend le script exécutable

# EXPOSE 9000 → indique que PHP-FPM écoute sur le port 9000. NGINX va communiquer avec WordPress via ce port

# CMD ["/setup.sh"] → au démarrage du conteneur, lance le script setup.sh