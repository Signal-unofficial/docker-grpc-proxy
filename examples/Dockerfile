ARG NODE_VERSION=node:lts-bookworm-slim@sha256:f752e4821362614eab35016f01dea3af61d2f59d0445381c25683e4331520a7b

FROM ${NODE_VERSION} AS local-python

# node-gyp depends on gcc, make and Python
# Everything else is an optional/required dependency of Python
RUN apt-get update -qq \
    # Shuts up interactive dependency installations
    && DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        tzdata \
    # https://github.com/python/devguide/issues/1654
    && apt-get install -yqq \
        build-essential \
        gcc \
        gdb \
        inetutils-inetd \
        lcov \
        libbz2-dev \
        libffi-dev \
        libgdbm-compat-dev \
        libgdbm-dev \
        liblzma-dev \
        libncurses5-dev \
        libreadline6-dev \
        libreadline6-dev \
        libssl-dev \
        libzstd-dev \
        lzma \
        lzma-dev \
        make \
        pkg-config \
        tk-dev \
        uuid-dev \
        zlib1g-dev \
    && apt-get clean -qq

# Downloading Python
WORKDIR /usr/local/bin/
# https://devguide.python.org/versions/#full-chart
ARG PYTHON_VERSION=3.13.7
ARG PYTHON_HASH=sha256:6c9d80839cfa20024f34d9a6dd31ae2a9cd97ff5e980e969209746037a5153b2
ADD --checksum=${PYTHON_HASH} \
    "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" \
    "./python.tgz"
RUN \
    tar -xzf './python.tgz' \
    && rm './python.tgz' \
    && mv "./Python-${PYTHON_VERSION}" "./python3"

# Installing Python
WORKDIR /usr/local/bin/python3/
RUN \
    './configure' \
    && make \
    && make test \
    && make install

ENV PYTHON="/usr/local/bin/python3/python"

FROM local-python AS example-service

RUN npm i -g node-gyp
WORKDIR /project/service/
# 1000:1000 corresponds to user node
COPY --chown=1000:1000 [ \
    "./package.json", \
    "./package-lock.json*", \
    "./npm-shrinkwrap.json*", \
    "./" \
]
RUN npm i
COPY --link --chown=1000:1000 [ "./", "./" ]

USER node
CMD [ "npm", "start" ]
