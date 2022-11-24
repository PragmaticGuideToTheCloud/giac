
FROM python:3.7.5-slim-buster

RUN : INSTALL GENERAL PURPOSE PACKAGES \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bash \
    curl \
    git \
    inetutils-ping \
    net-tools \
    procps \
    unzip \
 && : APT FULL CLEANUP \
 && rm -rf /var/lib/apt/lists/*

ARG TINI_VERSION=0.18.0
ENV TINI_VERSION=$TINI_VERSION

RUN : INSTALL TINI \
 && curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 \
         -o /tini \
 && chmod +x /tini

RUN : SETUP NORMAL USER GROUP \
 && groupadd -g 1234 aiqaml \
 && : SETUP NORMAL USER ACCOUNT \
 && useradd -u 1234 -g 1234 -m -d /home/aiqaml/ -s /bin/bash aiqaml

COPY .cache/aiqa-ml-cluster/docker/Pipfile \
     .cache/aiqa-ml-cluster/docker/Pipfile.lock /tmp/

RUN : INSTALL RUNTIME DEPENDENCIES \
 && DEPS="${DEPS} libffi6" \
    DEPS="${DEPS} libssl1.1" \
    DEPS="${DEPS} libsnappy1v5" \
 && : INSTALL BUILD DEPENDENCIES \
 && BUILD_DEPS="${BUILD_DEPS} gcc g++" \
    BUILD_DEPS="${BUILD_DEPS} pkg-config" \
    BUILD_DEPS="${BUILD_DEPS} libffi-dev" \
    BUILD_DEPS="${BUILD_DEPS} libssl-dev" \
    BUILD_DEPS="${BUILD_DEPS} libsnappy-dev" \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y $DEPS $BUILD_DEPS \
 && pip --no-cache-dir install pipenv \
 && : INSTALL PYTHON SOFTWARE STACK \
 && (cd /tmp/ && pipenv --clear install --system --deploy --dev) \
 && : PIPENV FULL CLEANUP \
 && rm -rf ~/.cache/pipenv/ \
 && : APT FULL CLEANUP \
 && apt-get -q remove -y $BUILD_DEPS \
 && apt-get -q autoremove -y \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

COPY worker.ENTRYPOINT /worker.ENTRYPOINT
RUN chmod +x /worker.ENTRYPOINT

ENTRYPOINT ["/tini", "--", "/worker.ENTRYPOINT"]

COPY .cache/aiqa-ml-cluster/ /aiqa-ml-cluster/
RUN chown -R aiqaml:aiqaml /aiqa-ml-cluster/

USER aiqaml
WORKDIR /aiqa-ml-cluster/

RUN : INSTALL EDITABLE DEVELOPMENT PACKAGE \
 && pip install --user --editable .

CMD : RUN CELERY WORKER \
 && cd aiqaml/ \
 && celery worker \
    --app=modules.tasks.main_task \
    --concurrency=1 \
    --loglevel=${LOG_LEVEL:-INFO}

# vim:ts=2:sw=2:et:syn=dockerfile:
