FROM python:3
ENV PYTHONUNBUFFERED=1
WORKDIR /code
ARG PROJECT_NAME
ARG SRC_CODE_DIR
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR/requirements.txt /code/
COPY wait-for-it.sh /
RUN pip install -r requirements.txt
COPY .cache/$PROJECT_NAME$SRC_CODE_DIR /code
WORKDIR /code
CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]
