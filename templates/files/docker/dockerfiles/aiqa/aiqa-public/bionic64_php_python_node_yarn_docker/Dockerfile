
FROM ubuntu:18.04

MAINTAINER sk4zuzu@gmail.com

# Install general-purpose packages
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bash \
    curl \
    git \
    gnupg2 \
    lsb-release \
    make \
    mysql-client \
    unzip \
    parallel \
    vim \
 && : APT FULL CLEANUP \
 && rm -rf /var/lib/apt/lists/*

ARG PHP_VERSION=7.3.7
ENV PHP_VERSION=$PHP_VERSION

ARG PHPENV_ROOT=/opt/phpenv
ENV PHPENV_ROOT=$PHPENV_ROOT

ENV PATH=$PHPENV_ROOT/shims:$PHPENV_ROOT/bin:$PATH

# Build and install php 7.3 interpreter
RUN DEPS= \
 && DEPS="${DEPS} bash curl git" \
    DEPS="${DEPS} libbz2-1.0" \
    DEPS="${DEPS} libcurl4" \
    DEPS="${DEPS} libjpeg9" \
    DEPS="${DEPS} libmcrypt4" \
    DEPS="${DEPS} libpng16-16" \
    DEPS="${DEPS} libreadline7" \
    DEPS="${DEPS} libssl1.1" \
    DEPS="${DEPS} libtidy5" \
    DEPS="${DEPS} libxml2" \
    DEPS="${DEPS} libxslt1.1" \
    DEPS="${DEPS} libzip4" \
 && BUILD_DEPS= \
 && BUILD_DEPS="${BUILD_DEPS} gcc g++ make pkg-config autoconf re2c" \
    BUILD_DEPS="${BUILD_DEPS} libbz2-dev" \
    BUILD_DEPS="${BUILD_DEPS} libcurl4-openssl-dev" \
    BUILD_DEPS="${BUILD_DEPS} libjpeg9-dev" \
    BUILD_DEPS="${BUILD_DEPS} libmcrypt-dev" \
    BUILD_DEPS="${BUILD_DEPS} libpng-dev" \
    BUILD_DEPS="${BUILD_DEPS} libreadline-dev" \
    BUILD_DEPS="${BUILD_DEPS} libssl-dev" \
    BUILD_DEPS="${BUILD_DEPS} libtidy-dev" \
    BUILD_DEPS="${BUILD_DEPS} libxml2-dev" \
    BUILD_DEPS="${BUILD_DEPS} libxslt1-dev" \
    BUILD_DEPS="${BUILD_DEPS} libzip-dev" \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y $DEPS $BUILD_DEPS \
 && : INSTALL PHPENV \
 && curl -fsSL https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash - \
 && : INSTALL PHP GLOBALLY \
 && phpenv install $PHP_VERSION \
 && phpenv global $PHP_VERSION \
 && phpenv rehash \
 && : APT FULL CLEANUP \
 && apt-get -q remove -y $BUILD_DEPS \
 && apt-get -q autoremove -y \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION=3.7.4
ENV PYTHON_VERSION=$PYTHON_VERSION

ARG PYENV_ROOT=/opt/pyenv
ENV PYENV_ROOT=$PYENV_ROOT

ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Build and install python 3.7 interpreter
RUN DEPS= \
 && DEPS="${DEPS} bash curl git llvm tk wget xz-utils" \
    DEPS="${DEPS} libbz2-1.0" \
    DEPS="${DEPS} libffi6" \
    DEPS="${DEPS} liblzma5" \
    DEPS="${DEPS} libncurses5" \
    DEPS="${DEPS} libncursesw5" \
    DEPS="${DEPS} libreadline7" \
    DEPS="${DEPS} libssl1.1" \
    DEPS="${DEPS} libsqlite3-0" \
    DEPS="${DEPS} zlib1g" \
 && BUILD_DEPS= \
 && BUILD_DEPS="${BUILD_DEPS} build-essential gcc g++ make pkg-config" \
    BUILD_DEPS="${BUILD_DEPS} libbz2-dev" \
    BUILD_DEPS="${BUILD_DEPS} libffi-dev" \
    BUILD_DEPS="${BUILD_DEPS} liblzma-dev" \
    BUILD_DEPS="${BUILD_DEPS} libncurses5-dev" \
    BUILD_DEPS="${BUILD_DEPS} libncursesw5-dev" \
    BUILD_DEPS="${BUILD_DEPS} libreadline-dev" \
    BUILD_DEPS="${BUILD_DEPS} libssl-dev" \
    BUILD_DEPS="${BUILD_DEPS} libsqlite3-dev" \
    BUILD_DEPS="${BUILD_DEPS} tk-dev" \
    BUILD_DEPS="${BUILD_DEPS} zlib1g-dev" \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y $DEPS $BUILD_DEPS \
 && : INSTALL PYENV \
 && curl -fsSL https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash - \
 && pyenv update \
 && : INSTALL PYTHON GLOBALLY \
 && pyenv install $PYTHON_VERSION \
 && pyenv global $PYTHON_VERSION \
 && pyenv rehash \
 && pip3 --no-cache-dir install --upgrade pip setuptools \
 && pyenv rehash \
 && : APT FULL CLEANUP \
 && apt-get -q remove -y $BUILD_DEPS \
 && apt-get -q autoremove -y \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

# Install cypress deps
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libxtst6 \
    libgtk3.0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    xvfb \
 && : APT FULL CLEANUP \
 && rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=10.16.3
ENV NODE_VERSION=$NODE_VERSION

ARG N_PREFIX=/opt/n
ENV N_PREFIX=$N_PREFIX

ENV PATH=$N_PREFIX/bin:$PATH

# Install nodejs using n-install
RUN BUILD_DEPS= \
 && BUILD_DEPS="${BUILD_DEPS} make" \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y $BUILD_DEPS \
 && curl -fsSL https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -n -y $NODE_VERSION \
 && : APT FULL CLEANUP \
 && apt-get -q remove -y $BUILD_DEPS \
 && apt-get -q autoremove -y \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

# Install ubuntu-native yarn (as recommended)
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends yarn \
 && : APT FULL CLEANUP \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

ARG DOCKER_CE_VERSION_APT=18.06.3~ce~3-0
ENV DOCKER_CE_VERSION_APT=$DOCKER_CE_VERSION_APT

# Install docker-ce
RUN BUILD_DEPS= \
 && BUILD_DEPS="${BUILD_DEPS} apt-transport-https" \
    BUILD_DEPS="${BUILD_DEPS} software-properties-common" \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y $BUILD_DEPS \
 && : DOCKER-CE GPG KEY \
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | apt-key add - \
 && : DOCKER-CE PACKAGES \
 && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y docker-ce=${DOCKER_CE_VERSION_APT}~ubuntu \
 && : APT FULL CLEANUP \
 && apt-get -q remove -y $BUILD_DEPS \
 && apt-get -q autoremove -y \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

ARG DOCKER_COMPOSE_VERSION=1.24.1
ENV DOCKER_COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION

# Install docker-compose
RUN : DOCKER-COMPOSE BINARY \
 && curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose

# Silence gnu parallel
RUN : SILENCE PARALLEL FOR ROOT USER \
 && install -o root -g root -m u=rwx,go= -d /root/.parallel/ \
 && install -o root -g root -m u=rw,go= /dev/null /root/.parallel/will-cite

# Customize config
COPY php.ini $PHPENV_ROOT/versions/$PHP_VERSION/etc/

ARG TINI_VERSION=0.18.0
ENV TINI_VERSION=$TINI_VERSION

# Install tini
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 \
         -o /tini \
 && chmod +x /tini

ENTRYPOINT ["/tini", "--"]

CMD /bin/bash

# vim:ts=2:sw=2:et:syn=dockerfile:
