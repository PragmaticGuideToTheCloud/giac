FROM ruby:latest
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /app
WORKDIR /app/
RUN gem install sinatra webrick
CMD ["ruby", "/app/src/app.rb", "-o", "0.0.0.0"]
