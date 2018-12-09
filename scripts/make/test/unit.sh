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

# Run unit tests.
./vendor/bin/phpunit
