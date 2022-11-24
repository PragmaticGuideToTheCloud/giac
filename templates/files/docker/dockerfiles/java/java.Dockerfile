FROM maven as build
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /app
RUN cd /app && mvn clean install

FROM openjdk:8-jdk-alpine
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
