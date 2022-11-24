FROM traefik:1.7.14-alpine
COPY traefik.toml /traefik.toml
ENTRYPOINT []
CMD exec traefik -c /traefik.toml
