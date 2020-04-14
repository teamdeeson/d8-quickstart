<?php

/**
 * @file
 * Default Drupal configuration file sites/default/settings.php.
 *
 * You should not normally need to modify this file.
 */

// Detect the environment.
require_once dirname(DRUPAL_ROOT) . '/src/settings/environment.inc';

// Configure the application.
foreach (glob(dirname(DRUPAL_ROOT) . '/src/settings/*.settings.inc') as $file) {
  require_once $file;
}
$databases['default']['default'] = array (
  'database' => 'drupal',
  'username' => 'drupal',
  'password' => 'drupal',
  'prefix' => '',
  'host' => 'mariadb',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
$settings['hash_salt'] = 'Jr70ilBrP67DUXv5H6G8-9zxzD4JK6vUHLkUx3vKVxEgUN9v_ixqK267cRdiW4pXOZVTtOMYjg';
