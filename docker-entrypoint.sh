#!/bin/bash

SYSTEM_UID=${GHOST_UID:-"1000"}
SYSTEM_UID_TYPE=$( [ ${GHOST_UID} ] && echo "preset" || echo "default" )

echo "==> Updating Ghost user's ID to ${SYSTEM_UID} (${SYSTEM_UID_TYPE})"
usermod -u ${SYSTEM_UID} ghost > /dev/null 2>&1

echo "==> Updating ownership of content directory (${GHOST_CONTENT})"
mkdir -p "${GHOST_CONTENT}"
chown -RH ghost "${GHOST_CONTENT}"

if [[ "$*" == npm*start* ]]; then
    echo "==> Installing Ghost data..."

    baseDir="$GHOST_SOURCE/content"

    for dir in "$baseDir"/*/ "$baseDir"/themes/*/; do
        targetDir="$GHOST_CONTENT/${dir#$baseDir/}"

        mkdir -p "$targetDir"

        if [ -z "$(ls -A "$targetDir")" ]; then
            tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
        fi
    done

    if [ ! -e "$GHOST_CONTENT/config.js" ]; then
        sed -r '
            s/127\.0\.0\.1/0.0.0.0/g;
            s!path.join\(__dirname, (.)/content!path.join(process.env.GHOST_CONTENT, \1!g;
        ' "$GHOST_SOURCE/config.example.js" > "$GHOST_CONTENT/config.js"
    fi

    ln -sf "$GHOST_CONTENT/config.js" "$GHOST_SOURCE/config.js"

    echo "==> Done!"
    echo "==> Starting Ghost"
fi

exec "$@"
