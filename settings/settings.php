<?php

/**
 * @file
 * Default Drupal configuration file sites/default/settings.php
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

foreach (glob(dirname(DRUPAL_ROOT) . '/settings/*.settings.inc') as $file) {
  require_once $file;
}
