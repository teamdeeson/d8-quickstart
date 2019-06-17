#!/usr/bin/env bash

set -e

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"

if [ ! -d "./make" ]; then
  version="master"
  if [ -f ./.dbf ]; then
    version=$(cat ./.dbf)
  fi

  docker run -v $(pwd):/app -w /app --env DBFVER=$version deeson/deployer /bin/bash \
    -c 'git clone -b "$DBFVER" --single-branch --depth 1 https://github.com/teamdeeson/drupal-build-framework.git make \
    && cd ./make \
    && rm -Rf .git'
fi
