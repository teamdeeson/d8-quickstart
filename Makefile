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
	# Configure Drupal Coder support.
	${ROOT_DIR}/vendor/bin/phpcs --config-set installed_paths ${ROOT_DIR}/vendor/drupal/coder/coder_sniffer
	# Run the coding standards checks.
	${ROOT_DIR}/vendor/bin/phpcs -nq --standard=Drupal --extensions=php,inc,module,theme ${ROOT_DIR}/src/
	# Run the Drupal best practice checks.
	${ROOT_DIR}/vendor/bin/phpcs -nq --standard=DrupalPractice --extensions=php,inc,module,theme ${ROOT_DIR}/src/
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
	if $(RUN_DESTRUCTIVE); then ./scripts/deploy.sh; else exit 1; fi

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
	cd docroot && ${DRUSH_CMD} site-install || echo 'Skipping site installation.'
	cd docroot && ${DRUSH} cim

# Do stuff to Drupal now it's in a live environment.
post-deploy:
	# No master yet :-( .
	cd docroot && $(DRUSH) cim sync
	cd docroot && $(DRUSH) updb
	cd docroot && $(DRUSH) cr
	cd docroot && $(DRUSH) cc css-js

# Start Docker using docker-sync
docker-up:
	docker-sync start
	docker-compose up -d

# Stop Docker and docker-sync
docker-down:
	docker-compose down
	docker-sync stop
