<?php

/**
 * @file
 * Drupal 8 settings for Bitbucket Pipelines.
 */

if (SETTINGS_PLATFORM == D_PLATFORM_PIPELINES && SETTINGS_ENVIRONMENT == D_ENVIRONMENT_LOCAL) {
  $databases['default']['default'] = [
    'database' => '../testdb.sqlite',
    'prefix' => '',
    'namespace' => 'Drupal\\Core\\Database\\Driver\\sqlite',
    'driver' => 'sqlite',
  ];
}
