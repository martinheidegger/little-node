#!/bin/bash


USER_ID="$(id -u node 2>/dev/null)"
if [ ! $USER_ID ]; then
  USER_ID=$(stat -c '%u' /usr/src/app)
  USER_ID=${USER_ID:-9001}
  echo "Creating the node user as ${USER_ID}"
  adduser -s /bin/bash -u $USER_ID -D -H node
fi

echo "Starting with UID: $USER_ID (node)"

if [ -z "$@" ]; then
  exec su-exec node /bin/bash
else
  exec su-exec node /bin/bash -c "$@"
fi
