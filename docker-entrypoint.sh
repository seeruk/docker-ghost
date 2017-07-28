#!/bin/sh

. "$(dirname $0)/docker-functions.sh"

set -x

# Wait for MySQL to start, if it is going to be used.
wait_for_mysql

cd "$GHOST_DIR"

GHOST_INSTALLED_VERSION=$(ghost version | grep '^Ghost Version' | grep -o '\d\.\d\.\d$')

# If Ghost is not installed...
if [ "$GHOST_INSTALLED_VERSION" == "" ]; then
    # Install and configure Ghost, we need to configure before we migrate.
    ghost_install
    ghost_config

    # After installation, migrate the database (if it's not already).
    ghost setup migrate
# If Ghost is installed, but not the desired version...
elif [ "$GHOST_INSTALLED_VERSION" != "$GHOST_VERSION" ]; then
    # We're assuming you'll always use this for upgrading, and the version will always increase or
    # stay the same, and never revert.
    ghost_update

    # @todo: Verify this work...
fi

# Always configure to the desired state.
ghost_config

exec "$@"
