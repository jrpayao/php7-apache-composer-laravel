#!/bin/sh
set -e
echo "[ ****************** ] Back - Starting Endpoint of Application"

if ! [ -d "./vendor" ]; then
    echo "[ ****** ] Generating dependencies of Laravel with Artisan..."
    echo "[ ****** ] Install dependencies whit composer..."
    composer install
    php artisan key:generate
fi

if ! [ -f ".env" ]; then
    echo "[ ****** ] .env not found."
    cp .env.dist .env

    echo "[ ****** ] Key Generate"
    php artisan key:generate

    echo "[ ****** ] DB Migration"
    php artisan migrate

    echo "[ ****** ] DB Seed"
    php artisan db:seed

fi

php artisan config:clear

echo "[ ****** ] Create necessaries folders "
mkdir -p ./storage/logs || true
mkdir -p ./storage/framework || true
mkdir -p ./storage/framework/cache || true
mkdir -p ./storage/framework/sessions || true
mkdir -p ./storage/framework/testing || true
mkdir -p ./storage/framework/views || true


if ! [ -d "./storage/fonts" ]; then
    echo "[ ****** ] Create storage/fonts folder"
    mkdir ./storage/fonts
fi

echo "[ ****** ] Giving write permission to storage folder"
chmod -R 777 ./storage/*

echo "[ ****************** ] Back - Ending Endpoint of Application"
/usr/sbin/httpd -D FOREGROUND
exec "$@"