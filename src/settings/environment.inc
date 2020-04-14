<?php

/**
 * @file
 * Detect the current system environment.
 */

const D_ENVIRONMENT_LOCAL = 'local';
const D_ENVIRONMENT_DEV = 'dev';
const D_ENVIRONMENT_TEST = 'test';
const D_ENVIRONMENT_PROD = 'prod';

const D_PLATFORM_DOCKER = 'docker';
const D_PLATFORM_PIPELINES = 'pipelines';
const D_PLATFORM_ACQUIA = 'acquia';
const D_PLATFORM_PANTHEON = 'pantheon';
const D_PLATFORM_PLATFORMSH = 'platformsh';

/**
 * Map domains to environment types here.
 */
$base_domains = [
  getenv('D4D_HOSTNAME') => 'local',
  'docker.local' => 'local',
  'dev.example.com' => 'dev',
  'test.example.com' => 'test',
  'www.example.com' => 'prod',
];

$platform = '';
$env = '';
$instance = $_SERVER['HTTP_HOST'];

// Pantheon environment settings.
if (isset($_ENV['PANTHEON_ENVIRONMENT'])) {
  $platform = D_PLATFORM_PANTHEON;

  // Dev / test / live environment.
  switch ($_ENV['PANTHEON_ENVIRONMENT']) {
    case 'dev':
      $env = D_ENVIRONMENT_DEV;
      break;

    case 'test':
      $env = D_ENVIRONMENT_TEST;
      break;

    case 'live':
      $env = D_ENVIRONMENT_PROD;
      break;

    default:
      $env = D_ENVIRONMENT_DEV;
      $pantheon_domain = $_ENV['PANTHEON_ENVIRONMENT'] .
        '-' . $_ENV['PANTHEON_SITE_NAME'] .
        '.pantheonsite.io';
      $base_domains[$pantheon_domain] = D_ENVIRONMENT_DEV;
      break;
  }
}
// Acquia environment settings.
elseif (isset($_ENV['AH_SITE_ENVIRONMENT'])) {
  $platform = D_PLATFORM_ACQUIA;

  // Live environment.
  if (!empty($_ENV['AH_PRODUCTION'])) {
    $env = D_ENVIRONMENT_PROD;
  }
  // Other Acquia environment.
  else {
    $env = $_ENV['AH_SITE_ENVIRONMENT'];
  }
}
// Platform.sh environment settings.
elseif (isset($_ENV['PLATFORM_APPLICATION'])) {
  $platform = D_PLATFORM_PLATFORMSH;

  switch (strtolower($_ENV['PLATFORM_BRANCH'])) {
    case 'master':
      $env = D_ENVIRONMENT_PROD;
      break;

    case 'develop':
      $env = D_ENVIRONMENT_TEST;
      break;

    default:
      $env = D_ENVIRONMENT_DEV;
      break;
  }
}
elseif (getenv('DOCKER_LOCAL')) {
  // Local environment settings - see 90-docker-settings.inc.
  $platform = D_PLATFORM_DOCKER;
  $env = $base_domains[getenv('D4D_HOSTNAME')];
  $instance = getenv('D4D_HOSTNAME');
}
else {
  // Running under Pipelines.
  $platform = D_PLATFORM_PIPELINES;
  $env = D_ENVIRONMENT_LOCAL;
  $instance = 'localhost';
}

if (!empty($env) && !empty($platform)) {
  if (empty($instance) && php_sapi_name() != 'cli') {
      \Drupal::messenger()->addWarning('SETTINGS_INSTANCE is not set and we were not invoked from the CLI.');
  }
  define('SETTINGS_PLATFORM', $platform);
  define('SETTINGS_ENVIRONMENT', $env);
  define('SETTINGS_INSTANCE', $instance);
}
else {
  \Drupal::messenger()->addWarning('SETTINGS_PLATFORM and/or SETTINGS_ENVIRONMENT is not set.');
}
