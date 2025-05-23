FROM nginx:1.28.0-alpine

LABEL maintainer="amralaayassen <amralaayassen22@gmail.com.com>"
LABEL version="1.0.0"
LABEL description="NGINX server hosting a basic HTML"

FROM nginxinc/nginx-unprivileged:stable-alpine
USER root
ARG DOCROOT=/usr/share/nginx/html
COPY --chown=nobody:nobody . ${DOCROOT}
RUN find ${DOCROOT} -type d -print0 | xargs -0 chmod 755 && \
    find ${DOCROOT} -type f -print0 | xargs -0 chmod 644 && \
    chmod 755 ${DOCROOT}

USER nginx
EXPOSE 8080
