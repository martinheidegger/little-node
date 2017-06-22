#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=$(stat -c '%u' /usr/src/app)
USER_ID=${USER_ID:-9001}

echo "Starting with UID : $USER_ID"
adduser -s /bin/bash -u $USER_ID -D -H node

exec su-exec node /bin/bash -c "$@"
