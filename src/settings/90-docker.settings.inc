<?php

/**
 * @file
 * Drupal 8 settings for docker.
 */

if (SETTINGS_ENVIRONMENT == 'local' && SETTINGS_HOSTING == 'docker') {
  $databases['default']['default'] = [
    'database' => getenv('DB_NAME') ? getenv('DB_NAME') : 'drupal',
    'username' => getenv('DB_USER') ? getenv('DB_USER') : 'drupal',
    'password' => getenv('DB_PASSWORD') ? getenv('DB_PASSWORD') : 'drupal',
    'prefix' => '',
    'host' => getenv('DB_HOST') ? getenv('DB_HOST') : '127.0.0.1',
    'port' => '3306',
    'driver' => getenv('DB_DRIVER') ? getenv('DB_DRIVER') : 'mysql',
  ];

  if ($databases['default']['default']['host'] === '127.0.0.1') {
    $databases['default']['default']['port'] = '3307';
  }

  $https = TRUE;

  if (!isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] != 'on') {
    $https = isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https';
    $_SERVER['HTTPS'] = $https ? 'on' : 'off';
  }

  $base_protocol = $https ? 'https' : 'http';
  $base_url = $base_protocol . '://localhost';

  // File paths...
  $conf['file_temporary_path'] = '/tmp';
  $settings['file_public_path'] = 'sites/default/files';
  $settings['file_private_path'] = '/private';

  // Configure Redis.

  $settings['redis.connection']['host'] = 'redis';
  $settings['redis.connection']['port'] = '6379';
  $settings['redis.connection']['password'] = '';
  $settings['redis.connection']['base'] = 0;
}
