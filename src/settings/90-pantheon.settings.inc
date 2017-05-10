<?php

/**
 * @file
 * Pantheon settings file shim.
 */

if (isset($_ENV['PANTHEON_ENVIRONMENT'])) {
  require_once DRUPAL_ROOT . '/sites/default/settings.pantheon.php';

  // (Re)Configure Redis for the Pantheon environment.
  $settings['redis.connection']['interface'] = 'PhpRedis';
  // Configure the Redis connection.
  $settings['redis.connection']['host'] = $conf['redis_client_host'];
  $settings['redis.connection']['port'] = $conf['redis_client_port'];
  $settings['redis.connection']['password'] = $conf['redis_client_password'];
}
