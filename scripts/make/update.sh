#!/usr/bin/env bash

script_path=$(dirname $0)
drush_alias="$1"
if [ "$drush_alias" == "" ]; then
  drush_alias="docker"
fi

drush_args="$2"

working_dir=$(pwd)
cd "$script_path"
cd ../..
repo_root=$(pwd)

source "$repo_root/.build.env"

if [ "$drupal_version" == "7" ]; then
  drush "@${drush_alias}" rr --no-cache-clear \
    && drush "@${drush_alias}" "${drush_args}" cc drush \
    && drush "@${drush_alias}" "${drush_args}" updb -y \
    && drush "@${drush_alias}" "${drush_args}" en -y master \
    && drush "@${drush_alias}" "${drush_args}" cc drush \
    && drush "@${drush_alias}" "${drush_args}" master-exec -y --no-cache-clear \
    && drush "@${drush_alias}" "${drush_args}" cc all \
    && drush "@${drush_alias}" "${drush_args}" cc drush \
    && drush "@${drush_alias}" "${drush_args}" fl
elif [ "$drupal_version" == "8" ]; then
  drush "@${drush_alias}" "${drush_args}" cim sync -y \
    && drush "@${drush_alias}" "${drush_args}" updb -y \
    && drush "@${drush_alias}" "${drush_args}" updb -y --entity-updates \
    && drush "@${drush_alias}" "${drush_args}" cr
fi
