#!/bin/bash

set -e
set -x

DIR=$(realpath $(dirname "$0"))
USER=$(whoami)
command -v phpenv >/dev/null 2>&1 && PHP_VERSION=$(phpenv version-name) || PHP_VERSION=$(php -r "echo phpversion();")
command -v phpenv >/dev/null 2>&1 && PHP_FPM_BIN="$HOME/.phpenv/versions/$PHP_VERSION/sbin/php-fpm" || PHP_FPM_BIN=$(command -v php-fpm)

ROOT=$(realpath "$DIR/..")
PORT=9876
SERVER="/tmp/php.sock"

function tpl {
    sed \
        -e "s|{DIR}|$DIR|g" \
        -e "s|{PHP_VERSION}|$PHP_VERSION|g" \
        -e "s|{ROOT}|$ROOT|g" \
        -e "s|{PORT}|$PORT|g" \
        -e "s|{SERVER}|$SERVER|g" \
        < $1 > $2
}

rm -rf "$DIR/nginx" "$DIR/var"

# Make some working directories.
mkdir "$DIR/nginx"
mkdir "$DIR/nginx/sites-enabled"
mkdir "$DIR/var"

PHP_FPM_CONF="$DIR/nginx/php-fpm.conf"

# Build the php-fpm.conf.
tpl "$DIR/php-fpm.tpl.conf" "$PHP_FPM_CONF"

# Start php-fpm
[[ -f /tmp/php-fpm.pid ]] && pkill -F /tmp/php-fpm.pid
"$PHP_FPM_BIN" --fpm-config "$PHP_FPM_CONF" --pid /tmp/php-fpm.pid

# Build the default nginx config files.
tpl "$DIR/nginx.tpl.conf" "$DIR/nginx/nginx.conf"
tpl "$DIR/fastcgi.tpl.conf" "$DIR/nginx/fastcgi.conf"
tpl "$DIR/default-site.tpl.conf" "$DIR/nginx/sites-enabled/default-site.conf"

# Start nginx.
[[ -f /tmp/nginx.pid ]] && pkill -F /tmp/nginx.pid
nginx -c "$DIR/nginx/nginx.conf"
