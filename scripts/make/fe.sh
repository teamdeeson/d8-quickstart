#!/bin/bash

set -e

# Install frontend build bits on bitbucket pipelines.
if [ $(command -v apk) ]; then
    apk update
    apk add build-base gcc abuild binutils libpng-dev autoconf automake build-base libtool nasm
    npm -g install yarn
fi;

# Build the frontend.
cd src/frontend
yarn
yarn build
cd ../../
