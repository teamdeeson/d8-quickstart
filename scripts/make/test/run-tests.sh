#!/usr/bin/env bash

# Standard build tools boilerplate
script_args=$@
script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../../..
repo_root=$(pwd)

source "$repo_root/.build.env"

set -e

if [ "$drupal_build" == "Y" ]; then
  docker run -ti -v $repo_root:/var/www/html -w /var/www/html "$drupal_build_php_tag" "./scripts/make/test/run-test.sh" "$script_args"
fi
