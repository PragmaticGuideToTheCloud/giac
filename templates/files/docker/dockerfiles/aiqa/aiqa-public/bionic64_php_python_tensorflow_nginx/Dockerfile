
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

RUN DEPS= \
 && DEPS="${DEPS} bash curl git" \
    DEPS="${DEPS} libsnappy1v5" \
 && BUILD_DEPS= \
 && BUILD_DEPS="${BUILD_DEPS} gcc g++ make pkg-config autoconf" \
    BUILD_DEPS="${BUILD_DEPS} libsnappy-dev" \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y $DEPS $BUILD_DEPS \
 && : INSTALL SNAPPY EXTENSION \
 && git clone --depth=1 https://github.com/kjdev/php-ext-snappy.git /tmp/php-ext-snappy/ \
 && (cd /tmp/php-ext-snappy/ \
 &&  phpize \
 &&  ./configure --with-snappy-includedir=/usr \
 &&  make install \
 &&  echo "extension=snappy.so" | tee $PHPENV_ROOT/versions/$PHP_VERSION/etc/conf.d/snappy.ini) \
 && rm -rf /tmp/php-ext-snappy/ \
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

# Install python-based ML software stack
RUN pip3 --no-cache-dir install \
    keras \
    matplotlib \
    pandas \
    scikit-learn \
    scikit-multilearn \
    tensorflow==1.14.0 \
 && pyenv rehash

ARG NGINX_VERSION_APT=1.17.0-1
ENV NGINX_VERSION_APT=$NGINX_VERSION_APT

# Install nginx
RUN : MAINLINE NGINX PACKAGES \
 && echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" \
    | tee /etc/apt/sources.list.d/nginx.list \
 && : IMPORT NGINX KEY \
 && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && : VERIFY NGINX KEY \
 && apt-key fingerprint ABF5BD827BD9BF62 \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -q install -y nginx=${NGINX_VERSION_APT}~$(lsb_release -cs) \
 && : APT FULL CLEANUP \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

# Pepare environment for nginx user
RUN : CHANGE HOME DIRECTORY AND SHELL OF NGINX USER \
 && install -o nginx -g nginx -m u=rwx,go= -d /home/nginx/ \
 && usermod -d /home/nginx -s /bin/bash nginx \
 && : ENABLE PHPENV AND PYENV FOR ALL USERS \
 && echo export PHPENV_ROOT=${PHPENV_ROOT}                         >/etc/profile.d/phpenv.sh \
 && echo export PATH=\$PHPENV_ROOT/shims:\$PHPENV_ROOT/bin:\$PATH >>/etc/profile.d/phpenv.sh \
 && echo export PYENV_ROOT=${PYENV_ROOT}                           >/etc/profile.d/pyenv.sh \
 && echo export PATH=\$PYENV_ROOT/shims:\$PYENV_ROOT/bin:\$PATH   >>/etc/profile.d/pyenv.sh

# Silence gnu parallel
RUN : SILENCE PARALLEL FOR ROOT USER \
 && install -o root -g root -m u=rwx,go= -d /root/.parallel/ \
 && install -o root -g root -m u=rw,go= /dev/null /root/.parallel/will-cite \
 && : SILENCE PARALLEL FOR NGINX USER \
 && install -o nginx -g nginx -m u=rwx,go= -d /home/nginx/.parallel/ \
 && install -o nginx -g nginx -m u=rw,go= /dev/null /home/nginx/.parallel/will-cite

# Customize config
COPY php.ini  $PHPENV_ROOT/versions/$PHP_VERSION/etc/
COPY www.conf $PHPENV_ROOT/versions/$PHP_VERSION/etc/php-fpm.d/

ARG TINI_VERSION=0.18.0
ENV TINI_VERSION=$TINI_VERSION

# Install tini
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 \
         -o /tini \
 && chmod +x /tini

ENTRYPOINT ["/tini", "--"]

CMD /bin/bash

# vim:ts=2:sw=2:et:syn=dockerfile:
