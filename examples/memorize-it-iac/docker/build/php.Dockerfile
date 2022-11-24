FROM webdevops/php-apache:5.6

RUN \
    apt-get update -y && \
    apt-get install -y \
    httpie \
    mysql-client \
    vim

WORKDIR /app

ARG PROJECT_NAME
ARG SRC_CODE_DIR
ARG ENV

COPY [".cache/$PROJECT_NAME$SRC_CODE_DIR/composer.json", ".cache/$PROJECT_NAME$SRC_CODE_DIR/composer.lock", "/app/"]
RUN composer install  --no-scripts --no-autoloader

ENV WEB_DOCUMENT_ROOT=/app/web
ENV WEB_DOCUMENT_INDEX=/app.php

COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /app

RUN chmod 777 /app/web

# backend
RUN \
    composer install && \
    rm -rf /app/app/cache/* && \
    rm -rf /app/app/logs/* && \
    chmod -R 777 /tmp && \
    mkdir -p /app/app/cache && \
    mkdir -p /app/app/logs && \
    chmod -R 777 /app/app/cache && \
    chmod -R 777 /app/app/logs && \
    chmod -R o+r,o+x /app
