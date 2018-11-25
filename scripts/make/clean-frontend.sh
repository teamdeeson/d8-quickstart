#!/usr/bin/env bash

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../..
repo_root=$(pwd)

source "$repo_root/.build.env"

for dir in "${frontend_clean_list[@]}"
do
  rm -rf "$dir"
done
