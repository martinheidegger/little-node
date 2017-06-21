FROM alpine:latest

WORKDIR /usr/src/app

ENV BUNDLE_PATH=/usr/local/bundle

# for node and/or package builds: gcc g++ libgcc binutils-gold linux-headers make openssl openssh-client python
# for node/npm installs: curl git
# for npm installation and other use-cases: tar
# for packages: man
# for ci: bash
RUN mkdir -p /usr/src/app \
    && adduser -D node \
    && chown -R node /usr/src \
    && chown -R node /usr/local \
    && apk update \
    && apk add --no-cache make bash gcc g++ man linux-headers curl git openssl openssh-client \
                          python binutils-gold gnupg tar libgcc \
    ## For the build of node
    && curl -sL https://raw.githubusercontent.com/martinheidegger/install-node/master/install_node.sh | \
       NODE_VERSION="v6.10.2" \
       NODE_VARIANT="make" \
       bash \
    && su node -c "npm i npm@latest -g" \
    && rm -rf /var/lib/apt/lists/* /usr/share/perl* || true

USEmmnode
