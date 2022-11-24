FROM ruby:3.0.0
WORKDIR /app/
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY [".cache/$PROJECT_NAME$SRC_CODE_DIR/Gemfile", ".cache/$PROJECT_NAME$SRC_CODE_DIR/Gemfile.lock", "./"]
RUN bundle install
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /app/
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]
