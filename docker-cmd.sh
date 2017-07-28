#!/bin/sh

. "$(dirname $0)/docker-functions.sh"

cd "$GHOST_DIR"

set -x

ghost run \
    --development="$(ghost_is_development)" \
    --no-prompt
