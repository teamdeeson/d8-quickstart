ENVIRONMENT?=docker
DRUSH_ARGS?=-y --nocolor
HOST=php
SOLR_HOST=solr
COMMAND=/bin/bash


#
# Key targets
#

# Shortcut for make install, make build and make start
default: install build start

# Install dependencies
install:
	./scripts/make/install.sh

# Build all static assets
build:
	./scripts/make/build.sh

# Start Docker Compose services but assume dependencies and build has already taken place
start:
	@echo Bringing docker containers up
	docker-compose up -d
	docker-compose ps

# Run all tests
test:
	./scripts/make/test.sh

# Update Drupal
update:
	./scripts/make/update.sh ${ENVIRONMENT} ${DRUSH_ARGS}

# Set the alias required by Xdebug
xdebug:
	sudo ifconfig lo0 alias 10.254.254.25



#
# Targets for interacting with Docker Compose
#

# Stop docker
stop:
	docker-compose down --remove-orphans

# Restart docker
restart: stop start

# Connect to the shell on a docker host, defaults to HOST=php COMMAND=/bin/bash
# Usage: make shell HOST=[service name] COMMAND=[command]
shell:
	docker-compose exec $(HOST) $(COMMAND)



#
# Targets for orchestrating project build
#

# Initialise Apache Solr core in service container for Apache Solr (without Search API).
build-solr:
	make shell HOST=$(SOLR_HOST) COMMAND='make core=core1 config_set=apachesolr -f /usr/local/bin/actions.mk'

# Initialise Apache Solr core in service container for Apache Solr (via Search API).
build-searchapi-solr:
	make shell HOST=$(SOLR_HOST) COMMAND='make core=core1 -f /usr/local/bin/actions.mk'



#
# Targets for cleaning project build artefacts
#

# Remove everything that's re-buildable. Running make build will reverse this.
clean: clean-drupal clean-frontend

# Remove NodeJS modules required by front-end
clean-node:
	./scripts/make/clean-node.sh

# Remove all front-end build artefacts including NodeJS modules
clean-frontend: clean-node
	./scripts/make/clean-frontend.sh

# Remove dependencies managed by Composer
clean-composer:
	./scripts/make/clean-composer.sh

# Remove Drupal dependencies managed by Drush Make including Composer dependencies
clean-drupal: clean-composer
	./scripts/make/clean-drupal.sh



#
# Targets for Bitbucket Pipelines
#

# Build Drupal under Pipelnes.
pipelines-build-drupal:
	./scripts/make/install-drupal.sh

# Build the frontend resources and copy them into the docroot under Pipelines
pipelines-build-frontend:
	./scripts/make/build-frontend.sh

# Relay to hosting platform provided Git repository under Pipelines.
pipelines-deploy:
	/opt/ci-tools/deployer.sh

# Run all the tests under Pipelines.
pipelines-test: pipelines-test-all

# Run only the coding standards tests under Pipelines.
pipelines-test-standards:
	./scripts/make/test/run-test.sh --standards

# Run only the unit tests under Pipelines.
pipelines-test-unit:
	./scripts/make/test/run-test.sh --unit

# Run only the behat tests under Pipelines.
pipelines-test-behat:
	./scripts/make/test/run-test.sh --behat

# Run all the tests under Pipelines.
pipelines-test-all:
	./scripts/make/test/run-test.sh --all



#
# Targets for interacting with Docker Compose
#

# Run all the tests.
test: test-all

# Run only the coding standards tests.
test-standards:
	./scripts/make/test/run-tests.sh --standards

# Run only the unit tests.
test-unit:
	./scripts/make/test/run-tests.sh --unit

# Run only the behat tests.
test-behat:
	./scripts/make/test/run-tests.sh --behat

# Run all the tests.
test-all:
	./scripts/make/test/run-tests.sh --all


#
# Targets specific to the project
#
# Note: Do not forget to precede the target definition with a comment explaining what it does!
#
