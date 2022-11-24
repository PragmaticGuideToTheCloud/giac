FROM nginx:alpine
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /usr/share/nginx/html
