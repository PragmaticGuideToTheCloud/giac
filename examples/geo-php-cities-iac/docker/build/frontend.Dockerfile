FROM node:15.5.0-alpine as build
WORKDIR /app
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY [".cache/$PROJECT_NAME$SRC_CODE_DIR/package.json", ".cache/$PROJECT_NAME$SRC_CODE_DIR/package-lock.json*", "./"]
RUN npm install --production
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /app
RUN npm run build

FROM nginx:1.17-alpine
COPY --from=build /app/build /usr/share/nginx/html
