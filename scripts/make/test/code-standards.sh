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

# On with the testing
PHPCS_CHECK_DIR="$tests_standards_check_dir"
if [ ! -z "$1" ]; then
  PHPCS_CHECK_DIR="$1"
fi
PHPCS_PATH="vendor/bin/phpcs"
PHPCBF_PATH="vendor/bin/phpcbf"
PHPCS_EXTENSIONS="php,inc,module,theme"
DRUPAL_EXCLUDED_SNIFFS=(
    Drupal.Commenting.DocComment
    Drupal.Commenting.ClassComment
)
IGNORE="$tests_standards_ignore"

echo "Running coding standard checks in ${PHPCS_CHECK_DIR}"


# Configure Drupal Coder support.
${PHPCS_PATH} --config-set installed_paths vendor/drupal/coder/coder_sniffer

# Run the coding standards checks.
EXCLUDE=$(IFS=, ; echo "${DRUPAL_EXCLUDED_SNIFFS[*]}")
${PHPCS_PATH} -nq --standard=Drupal --extensions=${PHPCS_EXTENSIONS} --exclude=${EXCLUDE} --ignore=${IGNORE} ${PHPCS_CHECK_DIR}
if [ $? != 0 ]; then
  exit $?
fi

# Run the Drupal best practice checks.
${PHPCS_PATH} -nq --standard=DrupalPractice --extensions=${PHPCS_EXTENSIONS} --ignore=${IGNORE} ${PHPCS_CHECK_DIR}
if [ $? != 0 ]; then
  exit $?
fi
