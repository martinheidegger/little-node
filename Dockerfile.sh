#!/bin/bash

NODE_VERSION="$(git rev-parse --abbrev-ref HEAD)"

if [[ -n $(git status --porcelain) ]]; then
  echo "GIT Dirty!"
  exit 1
fi

git checkout -b "${NODE_VERSION}" 2>/dev/null || git checkout "${NODE_VERSION}"

read -r -d '' Dockerfile << DOCKERFILE

FROM alpine:latest

WORKDIR /usr/src/app

ENV BUNDLE_PATH=/usr/local/bundle

# for node and/or package builds: gcc g++ libgcc binutils-gold linux-headers make openssl openssh-client python
# for node/npm installs: curl git
# for npm installation and other use-cases: tar
# for packages: man
# for ci: bash
# for mounted volume permissions: su-exec
RUN mkdir -p /usr/src/app \\
    && apk update \\
    && apk add --no-cache make bash gcc g++ man linux-headers curl git openssl openssh-client \\
                          python binutils-gold gnupg tar libgcc su-exec \\
    ## For the build of node
    && curl -sL https://raw.githubusercontent.com/martinheidegger/install-node/master/install_node.sh | \\
       NODE_VERSION="${NODE_VERSION}" \\
       NODE_VARIANT="make" \\
       bash \\
    && su node -c "npm i npm@latest -g" \\
    && rm -rf /var/lib/apt/lists/* /usr/share/perl* || true

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

DOCKERFILE

echo "${Dockerfile}"

echo "${Dockerfile}" > Dockerfile

git add Dockerfile
if [[ -n $(git status --porcelain) ]]; then
  git commit -m "Updated Dockerfile"
  git push -f -u origin "${NODE_VERSION}"
fi

