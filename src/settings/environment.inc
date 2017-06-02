<?php

/**
 * @file
 * Detect the current system environment.
 */

/**
 * Map domains to environment types here.
 */
$base_domains = [
  'localhost' => 'local',
  'dev-site.com' => 'dev',
  'test-site.com' => 'test',
  'live-site.com' => 'live',
];

// Pantheon environment settings.
if (isset($_ENV['PANTHEON_ENVIRONMENT'])) {
  define('SETTINGS_HOSTING', 'pantheon');

  // Dev / test / live environment.
  if (in_array($_ENV['PANTHEON_ENVIRONMENT'], ['dev', 'test', 'live'])) {
    define('SETTINGS_ENVIRONMENT', $_ENV['PANTHEON_ENVIRONMENT']);
  }
  else {
    // This is a Pantheon multi-dev environment.
    $pantheon_domain = $_ENV['PANTHEON_ENVIRONMENT'] .
      '-' . $_ENV['PANTHEON_SITE_NAME'] .
      '.pantheonsite.io';
    $base_domains[$pantheon_domain] = 'dev';

    define('SETTINGS_ENVIRONMENT', 'dev');
  }
}
// Acquia environment settings.
elseif (isset($_ENV['AH_SITE_ENVIRONMENT'])) {
  define('SETTINGS_HOSTING', 'acquia');

  // Live environment.
  if (!empty($_ENV['AH_PRODUCTION'])) {
    define('SETTINGS_ENVIRONMENT', 'live');
  }
  // Other Acquia environment.
  else {
    define('SETTINGS_ENVIRONMENT', $_ENV['PANTHEON_ENVIRONMENT']);
  }
}
// Platform.sh environment settings.
elseif (isset($_ENV['PLATFORM_APPLICATION'])) {
  define('SETTINGS_HOSTING', 'platformsh');

  switch (strtolower($_ENV['PLATFORM_BRANCH'])) {
    case 'master':
      define('SETTINGS_ENVIRONMENT', 'live');
      break;

    case 'develop':
      define('SETTINGS_ENVIRONMENT', 'test');
      break;

    default:
      define('SETTINGS_ENVIRONMENT', 'dev');
      break;
  }
}
else {
  // Environment settings for VDD.
  $local_settings = '/var/www/settings/PROJECT/settings.inc';
  if (file_exists($local_settings)) {
    require_once $local_settings;
    define('SETTINGS_ENVIRONMENT', 'local');
    define('SETTINGS_HOSTING', 'vdd');
  }
  elseif (getenv('DOCKER_LOCAL')) {
    define('SETTINGS_ENVIRONMENT', 'local');
    define('SETTINGS_HOSTING', 'docker');
  }
}
