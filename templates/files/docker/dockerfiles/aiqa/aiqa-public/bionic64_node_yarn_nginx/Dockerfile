
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
 && : APT FULL CLEANUP \
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
RUN usermod -s /bin/bash nginx \
 && echo export N_PREFIX=${N_PREFIX}        >/etc/profile.d/n.sh \
 && echo export PATH=\$N_PREFIX/bin:\$PATH >>/etc/profile.d/n.sh

ARG TINI_VERSION=0.18.0
ENV TINI_VERSION=$TINI_VERSION

# Install tini
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 \
         -o /tini \
 && chmod +x /tini

ENTRYPOINT ["/tini", "--"]

CMD /bin/bash

# vim:ts=2:sw=2:et:syn=dockerfile:
