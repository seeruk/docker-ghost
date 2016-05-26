FROM node:4.2-slim
MAINTAINER Elliot Wright <elliot@elliotwright.co>

ENV GHOST_CONTENT /var/lib/ghost
ENV GHOST_SOURCE /usr/src/ghost
ENV GHOST_UID 1000
ENV GHOST_VERSION 0.8.0

COPY docker-entrypoint.sh /

WORKDIR $GHOST_SOURCE

RUN \
    useradd -u 1000 -mU ghost && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        gcc \
        make \
        python \
        unzip \
        wget && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget -O ghost.zip "https://ghost.org/archives/ghost-${GHOST_VERSION}.zip" && \
    unzip ghost.zip && \
    npm install --production && \
    npm cache clean && \
    rm -rf /tmp/npm* && \
    chmod +x /docker-entrypoint.sh

RUN mkdir -p "$GHOST_CONTENT" && chown -R ghost: "$GHOST_CONTENT"

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME $GHOST_CONTENT

EXPOSE 2368

CMD ["npm", "start"]
