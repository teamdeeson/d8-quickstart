#!/usr/bin/env bash

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../..
repo_root=$(pwd)

source "$repo_root/.build.env"

rm -rf "$frontend_node_modules"
