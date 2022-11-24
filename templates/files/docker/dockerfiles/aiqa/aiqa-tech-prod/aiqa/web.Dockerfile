
FROM eu.gcr.io/<<< provider.gcp.project_id >>>/bionic64_node_yarn_nginx:761059f

MAINTAINER michal.opala@edulab.io

COPY .cache/AIQA/frontend/package.json \
     .cache/AIQA/frontend/yarn.lock \
     /app/frontend/

# Build up yarn cache
RUN cd /app/frontend/ && yarn install

COPY .cache/AIQA/frontend/                        /app/frontend/
COPY .cache/AIQA/documentation/aiqa-rest-api.html /app/frontend/dist/

# Workaround hardcoded configs (later in ENTRYPOINT)
RUN echo "API_URL=%%_API_URL_%%" >/app/frontend/.env

# Build static files
RUN cd /app/frontend/ && yarn run build

COPY .cache/AIQA/config/kubernetes/ /config/kubernetes/

COPY web.ENTRYPOINT /web.ENTRYPOINT
RUN chmod +x /web.ENTRYPOINT

ENTRYPOINT ["/tini", "--", "/web.ENTRYPOINT"]

CMD exec nginx -g "daemon off;"

# vim:ts=2:sw=2:et:syn=dockerfile:
