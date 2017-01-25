<?php

/**
 * @file
 * Default Drupal configuration file sites/default/settings.php.
 */

/**
 * Map domains to environment types here.
 */
$base_domains = [
  'your-project-name.dev' => 'local',
  'dev-site.com' => 'dev',
  'test-site.com' => 'test',
  'live-site.com' => 'live',
];

// Environment settings for VDD.
$local_settings = '/var/www/settings/PROJECT/settings.inc';
if (file_exists($local_settings)) {
  require_once $local_settings;
  define('SETTINGS_ENVIRONMENT', 'local');
  define('SETTINGS_HOSTING', 'vdd');
}

foreach (glob(dirname(DRUPAL_ROOT) . '/src/settings/*.settings.inc') as $file) {
  require_once $file;
}
