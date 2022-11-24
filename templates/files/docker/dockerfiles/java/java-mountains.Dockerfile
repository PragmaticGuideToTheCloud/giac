FROM openjdk:8-alpine

RUN : INSTALL GENERAL-PURPOSE PACKAGES \
 && apk --no-cache add \
    bash \
    maven

WORKDIR /app

ARG PROJECT_NAME
ARG SRC_CODE_DIR

COPY .cache/$PROJECT_NAME$SRC_CODE_DIR/pom.xml /app/

RUN : PREPARE JAVA DEPENDENCIES \
 && mvn -f pom.xml -P default dependency:go-offline

COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /app

ENTRYPOINT []

CMD exec mvn -P default clean spring-boot:run
