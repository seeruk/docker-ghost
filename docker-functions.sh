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

    ghost config database.connection.port "${GHOST_DB_PORT}"
}

# Install a fresh Ghost instance. We use a local DB first to avoid the local system checks (as we
# will not have MySQL in the image, etc.)
ghost_install() {
    ghost install ${GHOST_VERSION} \
        --db="sqlite3" \
        --ip="0.0.0.0" \
        --log="stdout" \
        --no-enable \
        --no-prompt \
        --no-setup \
        --no-stack \
        --no-start \
        --process="local"
}

# Update Ghost to a new version. An existing installation must be present.
ghost_update() {
    ghost update ${GHOST_VERSION} \
        --development=$(ghost_is_development) \
        --no-prompt
}

ghost_perms() {
    UID=$(stat -c "%u" "$GHOST_DIR")
    GID=$(stat -c "%g" "$GHOST_DIR")

    groupmod -o -g ${GID} ghost
    usermod -o -u ${UID} -g ${GID} ghost
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
