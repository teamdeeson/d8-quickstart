ROOT_DIR=${PWD}
RUN_DESTRUCTIVE?=false
ENVIRONMENT?=docker
BEHAT?=${ROOT_DIR}/vendor/bin/behat
DRUSH_ARGS?=-y --nocolor
DRUSH_PATH?=${ROOT_DIR}/vendor/bin/drush
DRUSH_CMD?=${DRUSH_PATH} @$(ENVIRONMENT)
DRUSH?=${DRUSH_CMD} $(DRUSH_ARGS)
COMPOSER?=$(shell command -v composer 2> /dev/null)

# Build by default.
default: build

# Build for the current environment.
build: build-${ENVIRONMENT}

# Environment aliases.
build-vdd: build-local
build-docker: build-local
build-dev: build-local

# Build dependencies for dev environments.
build-local:
	${COMPOSER} install
# Build dependencies for prod environment.
build-prod:
	${COMPOSER} install --no-dev --prefer-dist --ignore-platform-reqs --optimize-autoloader

# Run coding standards checks.
test-code-quality: build-dev
	./scripts/make/code_standards.sh "src scripts"
# Run unit tests.
test-phpunit: build-dev
	${ROOT_DIR}/vendor/bin/phpunit
# Run functional tests.
mock-services:
    # We have to get rid of sendmail because Drupal tries to send an e-mail during installation.
	mv /usr/sbin/sendmail /usr/sbin/sendmail_back
	echo "exit 0" > /usr/sbin/sendmail
	chmod +x /usr/sbin/sendmail
    # Pipelines doesn't come with drush, so we'll symlink our own into place.
	ln -s ${DRUSH_PATH} /usr/sbin/drush
test-behat: mock-services test-behat-no-mock
test-behat-no-mock: build-dev
    # Check if drush is present on the path and fail fast if it isn't.
	which drush
    # Install the site in a sqlite database
	cd docroot && ${DRUSH_PATH} si -y config_installer --db-url=sqlite://../testdb.sqlite
    # Start php built-in webserver in the background
    cd docroot && php -S localhost:8080 > /dev/null 2>&1 &
	cd docroot && ${BEHAT} --config=${ROOT_DIR}/behat.yml --profile=pipelines
# Run functional tests locally.
local-behat: build-dev
	cd docroot && ${BEHAT} --config=${ROOT_DIR}/behat.yml
# Run all automated tests
test: build-dev test-code-quality test-phpunit test-behat

# Deploy to hosting. Builds prod dependencies first. Tests MUST pass.
deploy:	test build-prod
	if $(RUN_DESTRUCTIVE); then ./scripts/make/deploy.sh; else exit 1; fi
# Alias deploy to allow different deployment strategies for different environments
deploy-test: deploy
deploy-stage: deploy
deploy-prod: deploy

# Cleanup
clean:
	rm -Rf ./docroot ./vendor ./web

# Installation script
install: install-${ENVIRONMENT}
# Do nothing. Don't re-install prod.
install-prod:
# Local installation
install-docker: install-vdd
install-vdd:
# Drupal needs the settings file to be writable.
	chmod 777 docroot/sites/default/settings.php
	cd docroot && ${DRUSH_CMD} -y site-install config_installer
# Get rid of any changes made to the settings file.
	git checkout src/settings/settings.php
	chmod 644 docroot/sites/default/settings.php

# Do stuff to Drupal now it's in a live environment.
post-deploy:
	# No master yet :-( .
	cd docroot && $(DRUSH) cim sync
	cd docroot && $(DRUSH) updb
	cd docroot && $(DRUSH) cr
	cd docroot && $(DRUSH) cc css-js

# Start Docker
docker-start: docker-up
docker-up: docker-local-ssl
	docker-compose up -d

# Stop Docker
docker-stop: docker-down
docker-down:
	docker-compose down

# Restart docker
docker-restart: docker-stop docker-start

docker-local-ssl: .persist/certs/local.key .persist/certs/local.crt
.persist/certs/local.%:
	mkdir -p ./.persist/certs
	./scripts/make/genlocalcrt.sh ./.persist/certs
