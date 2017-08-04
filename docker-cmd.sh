#!/bin/sh

. "$(dirname $0)/docker-functions.sh"

cd "$GHOST_DIR"

echo "==> Running Ghost..."
ghost run \
    --development="$(ghost_is_development)" \
    --no-prompt
