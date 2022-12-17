FROM node:15.5.0-alpine
WORKDIR /app
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY [".cache/$PROJECT_NAME$SRC_CODE_DIR/package.json", ".cache/$PROJECT_NAME$SRC_CODE_DIR/package-lock.json*", "./"]
RUN npm install --production
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /app
CMD [ "node", "./src/server.js" ]
