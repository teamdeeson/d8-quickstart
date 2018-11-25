#!/usr/bin/env bash

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../..
repo_root=$(pwd)

source "$repo_root/.build.env"

if [ "$drupal_build" == "Y" ]; then
  docker run -ti -v $repo_root:/var/www/html -w /var/www/html "$drupal_build_php_tag" /bin/bash -c "$drupal_install_command"
fi

if [ "$frontend_build" == "Y" ]; then
  cd "$frontend_dir"
  frontend_dir_absolute=$(pwd)
  cd "$working_dir"
  docker run -ti -v $frontend_dir_absolute:/app -w /app "$frontend_build_tag" /bin/bash -c "$frontend_install_command"
fi
