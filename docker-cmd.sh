#!/bin/sh

. "$(dirname $0)/docker-functions.sh"

cd "$GHOST_HOME"

ghost_start
