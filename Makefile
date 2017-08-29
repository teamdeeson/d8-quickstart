ROOT_DIR=${PWD}
RUN_DESTRUCTIVE?=false
ENVIRONMENT?=docker
DRUSH_ARGS?=-y --nocolor
DRUSH_CMD?=${ROOT_DIR}/vendor/bin/drush @$(ENVIRONMENT)
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
test-behat: build-dev
	cd docroot && ${ROOT_DIR}/vendor/bin/behat --config=${ROOT_DIR}/behat.yml
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

# Start Docker using docker-sync
docker-start: docker-up
docker-up: docker-local-ssl
	docker-sync start && docker-compose up -d

# Stop Docker and docker-sync
docker-stop: docker-down
docker-down:
	docker-compose down && docker-sync stop

# Restart docker
docker-restart: docker-stop docker-start

docker-local-ssl: .persist/certs/local.key .persist/certs/local.crt
.persist/certs/local.%:
	mkdir -p ./.persist/certs
	./scripts/make/genlocalcrt.sh ./.persist/certs
