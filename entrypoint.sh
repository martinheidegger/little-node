#!/bin/bash

USER_ID="$(id -u)"
# Only try to use the node user if we have a /usr/src/app directory
if [ -d /usr/src/app ]; then
  USER_ID="$(id -u node 2>/dev/null)"
  # Lets try to create a node user if it doesn't exist already
  if [ -z "${USER_ID}" ]; then
    USER_ID=$(stat -c '%u' /usr/src/app)
    # In case /usr/src/app is mounted it will have a different user
    # than the one logged in, lets use that userid for the new node user
    if [ "${USER_ID}" != "$(id -u)" ]; then
      USER_ID=${USER_ID:1004}
      echo "Creating the node user with id: ${USER_ID}"
      adduser -s /bin/bash -u $USER_ID -D node
    fi
  fi
fi

if [ -z "$@" ]; then
  CMD=""
else
  CMD="-c \"$@\""
fi

CMD="/bin/bash ${CMD}"

if [ "${USER_ID}" != "$(id -u)" ]; then
  echo "Starting with UID: ${USER_ID} (node)"
  CMD="su-exec node ${CMD}"
fi

${CMD}
exit $?
