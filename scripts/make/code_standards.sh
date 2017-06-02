#!/bin/bash

PHPCS_CHECK_DIR=$1
PHPCS_PATH="vendor/bin/phpcs"
PHPCBF_PATH="vendor/bin/phpcbf"
PHPCS_EXTENSIONS="php,inc,module,theme"
DRUPAL_EXCLUDED_SNIFFS=(
    Drupal.Commenting.DocComment
    Drupal.Commenting.ClassComment
)
IGNORE="src/frontend/assets"
IGNORE="$IGNORE,src/frontend/node_modules"
IGNORE="$IGNORE,src/themes/cc_admin_theme/css"
IGNORE="$IGNORE,src/frontend/src/font"

echo "Running coding standard checks in ${PHPCS_CHECK_DIR}"


# Configure Drupal Coder support.
${PHPCS_PATH} --config-set installed_paths vendor/drupal/coder/coder_sniffer

# Run the coding standards checks.
EXCLUDE=$(IFS=, ; echo "${DRUPAL_EXCLUDED_SNIFFS[*]}")
${PHPCS_PATH} -nq --standard=Drupal --extensions=${PHPCS_EXTENSIONS} --exclude=${EXCLUDE} --ignore=${IGNORE} ${PHPCS_CHECK_DIR}
if [ $? != 0 ]
then
    exit 1
fi

# Run the Drupal best practice checks.
${PHPCS_PATH} -nq --standard=DrupalPractice --extensions=${PHPCS_EXTENSIONS} --ignore=${IGNORE} ${PHPCS_CHECK_DIR}
if [ $? != 0 ]
then
    exit 1
fi
