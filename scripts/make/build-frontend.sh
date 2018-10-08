#!/usr/bin/env bash

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../..
repo_root=$(pwd)

source "$repo_root/.build.env"

if [ "$frontend_build" == "Y" ]; then
  cd "$frontend_dir" && "$frontend_pipelines_command"
fi
