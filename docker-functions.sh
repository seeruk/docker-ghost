#!/bin/sh

# Check if we're intending to run in development mode or not.
ghost_is_development() {
    if [ "$GHOST_ENV" == "development" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# Configure the ghost instance, this should happen shortly after installation, and also every time
# this image is started.
ghost_config() {
    ghost config \
        --db="$GHOST_DB" \
        --dbhost="$GHOST_DB_HOST" \
        --dbuser="$GHOST_DB_USER" \
        --dbpass="$GHOST_DB_PASS" \
        --dbname="$GHOST_DB_NAME" \
        --development="$(ghost_is_development)" \
        --no-prompt \
        --ip="0.0.0.0" \
        --log="stdout" \
        --process="local" \
        --url="$GHOST_URL"

    ghost config database.connection.port "${GHOST_DB_PORT}" --development="$(ghost_is_development)"
    ghost config paths.contentPath "${GHOST_CONTENT}" --development="$(ghost_is_development)"
}

# Copy necessary files around from the base Ghost installation, so that Ghost runs properly.
ghost_copy() {
    echo "==> Copying basic Ghost content..."
    rsync -al "$GHOST_HOME/content/" "$GHOST_CONTENT"
}

# Install a fresh Ghost instance. We use a local DB first to avoid the local system checks (as we
# will not have MySQL in the image, etc.)
ghost_install() {
    ghost install ${GHOST_VERSION} \
        --db="sqlite3" \
        --development="$(ghost_is_development)" \
        --dir="$GHOST_HOME" \
        --ip="0.0.0.0" \
        --log="stdout" \
        --no-enable \
        --no-prompt \
        --no-setup \
        --no-stack \
        --no-start \
        --process="local"
}

# Start Ghost.
ghost_start() {
    echo "==> Running Ghost..."
    ghost run \
        --development="$(ghost_is_development)" \
        --no-prompt
}

# Update Ghost to a new version. An existing installation must be present.
ghost_update() {
    echo "==> Updating Ghost..."
    ghost update ${GHOST_VERSION} \
        --development=$(ghost_is_development) \
        --no-prompt

    echo "==> Cleaning up after update..."
    pkill -2 ghost
}

ghost_perms() {
    echo "==> Updating Ghost user permissions..."
    UID=${GHOST_UID:-$(stat -c "%u" "$GHOST_CONTENT")}
    GID=${GHOST_GID:-$(stat -c "%g" "$GHOST_CONTENT")}

    groupmod -o -g ${GID} ghost
    usermod -o -u ${UID} -g ${GID} ghost

    chown -R ${UID}:${GID} "$GHOST_CONTENT"
    chown -R ${UID}:${GID} "$GHOST_HOME"
}

wait_for_mysql() {
    if [ "$GHOST_DB" != "mysql" ]; then
        return 0
    fi

    # @todo: hopefully port can be a variable soon?
    while ! nc -z "$GHOST_DB_HOST" "${GHOST_DB_PORT}"; do
        sleep 0.5
    done
}
