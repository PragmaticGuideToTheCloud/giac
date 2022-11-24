FROM nginx:1.17-alpine
COPY default.conf /etc/nginx/conf.d/default.conf
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /var/www/
