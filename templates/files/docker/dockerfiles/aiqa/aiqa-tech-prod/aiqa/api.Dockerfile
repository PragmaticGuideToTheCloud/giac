
FROM eu.gcr.io/<<< provider.gcp.project_id >>>/bionic64_php_python_tensorflow_nginx:761059f

MAINTAINER michal.opala@edulab.io

# Fix python and install httpie
RUN ln -s /opt/pyenv/shims/python3   /usr/local/bin/python3 \
 && ln -s /opt/pyenv/shims/python3.7 /usr/local/bin/python3.7 \
 && pip3 --no-cache-dir install httpie

COPY .cache/AIQA/backend/composer.json \
     .cache/AIQA/backend/composer.lock \
     /app/backend/

# Build up composer cache
RUN cd /app/backend/ \
 && composer install \
    --no-scripts \
    --no-autoloader \
    --prefer-dist

#RUN cd /app/backend/ \
# && ./bin/console cache:warmup --env=prod

COPY .cache/AIQA/backend/ /app/backend/
COPY .cache/AIQA/json-schema/ /app/json-schema/

RUN cd /app/backend/ && composer install

COPY .cache/AIQA/config/kubernetes/ /config/kubernetes/

ARG COMMIT

COPY .cache/AIQA/version.txt /app/version.txt
RUN echo "${COMMIT}" >/app/version.hsh

RUN chmod -R ugo+r /app/backend/ \
 && install -d -m ugo=rwx /aiqa-var/ \
                          /aiqa-var/cache/ \
                          /aiqa-var/logs/

VOLUME /app/backend/public/images/

COPY api.ENTRYPOINT /api.ENTRYPOINT
RUN chmod +x /api.ENTRYPOINT

ENTRYPOINT ["/tini", "--", "/api.ENTRYPOINT"]

CMD /opt/phpenv/versions/$PHP_VERSION/etc/init.d/php-fpm start \
 && exec nginx -g "daemon off;"

# vim:ts=2:sw=2:et:syn=dockerfile:
