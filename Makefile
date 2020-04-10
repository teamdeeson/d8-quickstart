#
# Optionally include a .env file.
#
-include .env

#
# You can choose to not use Docker for local development by specifying the USE_DOCKER=0 environment variable in
# your project .env file.  The default is to use Docker for local development.
#

USE_DOCKER ?= 1

#
# Ensure the local environment has the right binaries installed.
#

REQUIRED_BINS := php composer
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),,$(error Please install `$(bin)`)))

#
# Default is what happens if you only type make.
#

default: install start build

#
# Bring in the external project dependencies.
#

install: .env
ifeq ("${USE_DOCKER}","1")
	docker run --rm --interactive --tty  --volume $(PWD):/var/www/html:delegated wodby/drupal-php:7.3-dev /bin/bash -c "composer global require hirak/prestissimo; composer install"
else
	@echo "TBC ..."
fi

#
# Update all Composer dependencies.
#

update:
ifeq ("${USE_DOCKER}","1")
	docker run --rm --interactive --tty --volume $(PWD):/app  --volume $(PWD)/.persist/composer:/tmp composer update
fi

#
# Start the local development server.
#

start:
ifeq ("${USE_DOCKER}","1")
	@echo Bringing docker containers up
	docker-compose up -d
	docker-compose ps
else
	./vendor/bin/drush runserver
endif

stop:
ifeq ("${USE_DOCKER}","1")
	docker-compose down --remove-orphans
endif

restart: stop start

#
# Build stages: Setup and configure the application for the environment.
#

build: install-drupal

install-drupal:
ifeq ("${USE_DOCKER}","1")
	@echo Waiting for db to be ready ...
	@sleep 45
	./drush.wrapper @docker cr
	./drush.wrapper @docker cim --yes
	./drush.wrapper @docker uli
endif

#
# Linting / testing / formatting.
#

lint:
	@echo "TBC ..."

test:
	@echo "TBC ..."

format:
	@echo "TBC ..."

#
# Delete all non version controlled files to reset the project.
#

clean: stop
	rm -rf docroot vendor

#
# Generate project symlinks and other disposable assets and wiring.
#

.persist/public:
ifeq ("${USE_DOCKER}","1")
	mkdir -p .persist/public
endif

.persist/private:
ifeq ("${USE_DOCKER}","1")
	mkdir -p .persist/private
endif

.env:
	cp .env.example .env

docroot/sites/default/files/:
ifeq ("${USE_DOCKER}","1")
	ln -s ../../../.persist/public docroot/sites/default/files
endif

docroot/sites/default/files/tmp/:
	mkdir -p docroot/sites/default/files/tmp/

docroot/sites/default/settings.php:
	ln -s ../../../src/settings/settings.php docroot/sites/default/settings.php

docroot/modules/custom:
	ln -s ../../src/modules $@

docroot/themes/custom:
	ln -s ../../src/themes $@

docroot/profiles/custom:
	ln -s ../../src/profiles $@

#
# Commands which get run from composer.json scripts section.
#

composer--post-install-cmd: composer--post-update-cmd
composer--post-update-cmd: .persist/public \
                                .persist/private \
                                docroot/sites/default/settings.php \
                                docroot/modules/custom \
                                docroot/profiles/custom \
                                docroot/themes/custom;

#
# Helper CLI commands.
#

sql-cli:
ifeq ("${USE_DOCKER}","1")
	@docker-compose exec ${DB_HOST} mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME}
else
	@echo "You need to use whatever sqlite uses..."
endif

logs:
ifeq ("${USE_DOCKER}","1")
	docker-compose logs -f
else
	@echo "You need to use whatever sqlite uses..."
endif

xdebug:
	sudo ifconfig lo0 alias 10.254.254.254
