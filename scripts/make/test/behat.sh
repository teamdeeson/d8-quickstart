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

# Install test dependencies on bitbucket pipelines.
if [ $(command -v apk) ]; then
  #apk update
  #apk add build-base gcc abuild binutils libpng-dev autoconf automake build-base libtool nasm mysql-client
  apk --no-cache add sqlite
fi

mv /usr/sbin/sendmail /usr/sbin/sendmail_back
echo "exit 0" > /usr/sbin/sendmail
chmod +x /usr/sbin/sendmail

cd docroot
../vendor/bin/drush si "$tests_behat_install_profile" --db-url=sqlite://../testdb.sqlite -y

# Start php built-in webserver in the background
php -S localhost:8080 > /dev/null 2>&1 &

# Run behat tests.
cd "$repo_root"
./vendor/bin/behat --profile pipelines

# Revert any changes made to the settings file while installing Drupal for testing.
git checkout src
