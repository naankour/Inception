<?php
define('DB_NAME', getenv('MYSQL_DATABASE'));
define('DB_USER', getenv('MYSQL_USER'));
define('DB_PASSWORD', getenv('MYSQL_PASSWORD'));
define('DB_HOST', 'mariadb:3306');
define('DB_CHARSET', 'utf8');

$table_prefix = 'wp_';

define('WP_HOME', 'https://' . getenv('DOMAIN_NAME'));
define('WP_SITEURL', 'https://' . getenv('DOMAIN_NAME'));
define('WP_DEBUG', false);

if (!defined('ABSPATH'))
    define('ABSPATH', __DIR__ . '/');

require_once ABSPATH . 'wp-settings.php';