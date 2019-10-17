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

  DBFVER=$version
  clone_script='git clone -b "$DBFVER" --single-branch --depth 1 https://github.com/teamdeeson/drupal-build-framework.git make \
    && cd ./make \
    && rm -Rf .git';

  #If were not under pipelines, run in container, otherwise we're already in a container, run locally.
  if [ -z "$CI" ]; then
    docker run -v $(pwd):/app -w /app --env DBFVER=$version deeson/deployer /bin/bash -c "$clone_script"
  else
    eval "$clone_script"
  fi
fi
