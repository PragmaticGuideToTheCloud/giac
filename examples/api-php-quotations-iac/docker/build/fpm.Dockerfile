FROM php:8-fpm-alpine
ARG PROJECT_NAME
ARG SRC_CODE_DIR
WORKDIR /var/www/
COPY [".cache/$PROJECT_NAME$SRC_CODE_DIR/composer.json", ".cache/$PROJECT_NAME$SRC_CODE_DIR/composer.lock", "/var/www/"]
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer self-update
RUN composer install  --no-scripts --no-autoloader
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /var/www/
RUN composer install
EXPOSE 9000
