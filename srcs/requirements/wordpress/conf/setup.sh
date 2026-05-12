#!/bin/bash
set -x

# Attendre que MariaDB soit prêt
until mysqladmin ping -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    echo "En attente de MariaDB..."
    sleep 2
done

echo "MariaDB est prêt ✔"

cd /var/www/html
# Télécharger WordPress seulement si pas déjà fait
if [ ! -f "/var/www/html/wp-login.php" ]; then
    # Télécharger les fichiers WordPress
    wp core download --allow-root --locale=fr_FR

    # Créer le wp-config.php directement depuis les variables d'environnement
    wp config create \
        --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306

    # Installer WordPress avec les infos du .env
    wp core install \
        --allow-root \
        --url=${DOMAIN_NAME} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}
        
    # Créer un deuxième utilisateur (obligatoire par le sujet 42)
    wp user create \
        --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD}

    echo "WordPress installé ✔"
fi

# Lancer PHP-FPM en foreground
exec php-fpm7.4 -F