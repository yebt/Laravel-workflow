# Laravel-workflow

## Commands

Show status

```sh
docker-compose ps
```

Up all services

```sh
docler-compse up -d
```

Down all services

```sh
docker-compose down
```


## Instance a nenw project


```sh
# me conecto al container
docker exec laravel_app bash
# ejecuto EN EL CONTAINER
composer create-project --prefer-dist laravel/laravel:^7.0 .
# Dar mermisos EN EL HOST
chmod -R 777 storage/
```

Cambiar el .env

```.env
DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
DB_HOST=mysql_server
DB_PORT=3306
DB_DATABASE=webdesk_db
DB_USERNAME=webdesk_user
DB_PASSWORD=webdesk_password
```

