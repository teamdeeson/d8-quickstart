#!/usr/bin/env bash

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../..
repo_root=$(pwd)

source "$repo_root/.build.env"

if [ "$drupal_build_composer_install" == "Y" ]; then
  composer install
fi

if [ "$drupal_build_drush_make" == "Y" ]; then
  cd docroot \
    && ../vendor/bin/drush @none make -y --nocolor --no-recursion ../drush-make.yml
  cd ..
fi

if [ "$drupal_fix_settings" == "Y" ]; then
  chmod u+w docroot/sites/* docroot/sites/*/settings.php
fi
