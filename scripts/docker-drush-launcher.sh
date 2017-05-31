#!/usr/bin/env bash
docker-compose exec --user 82 php drush "${@:3}"
