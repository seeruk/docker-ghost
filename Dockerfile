FROM node:boron-alpine
MAINTAINER Elliot Wright <hello@elliotdwright.com>

# Build setup options
ARG GHOST_UID=368
ARG GHOST_CLI_VERSION=1.0.0

# Directory options
ENV GHOST_DIR=/opt/ghost

# Startup options
ENV GHOST_DB=mysql
ENV GHOST_DB_HOST=db.docker
ENV GHOST_DB_USER=ghost
ENV GHOST_DB_PASS=ghost
ENV GHOST_DB_NAME=ghost
ENV GHOST_URL=http://localhost:2368
ENV GHOST_ENV=production
ENV GHOST_VERSION=1.1.0
ENV NODE_ENV=production

COPY docker-cmd.sh /usr/bin/docker-cmd.sh
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
COPY docker-functions.sh /usr/bin/docker-functions.sh

WORKDIR ${GHOST_DIR}

RUN set -x \
    && adduser -u ${GHOST_UID} -HD ghost \
    && apk add --no-cache \
        ca-certificates \
        curl \
        netcat-openbsd \
    && mkdir -p ${GHOST_DIR} \
    && mkdir -p /home/ghost \
    && chown -R ghost: ${GHOST_DIR} \
    && chown -R ghost: /home/ghost \
    && yarn global add ghost-cli@latest knex-migrator \
    && yarn cache clean \
    && chmod +x /usr/bin/docker-cmd.sh \
    && chmod +x /usr/bin/docker-entrypoint.sh \
    && chmod +x /usr/bin/docker-functions.sh

EXPOSE 2368

VOLUME ${GHOST_DIR}

USER ghost

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["docker-cmd.sh"]
