#!/bin/sh

. "$(dirname $0)/docker-functions.sh"

# Wait for MySQL to start, if it is going to be used.
wait_for_mysql

cd "$GHOST_HOME"

# Update permissions of `ghost` user
ghost_perms

echo "==> Stepping down, running pre-start..."
su-exec ghost "$(dirname $0)/docker-pre-start.sh" "$@"
