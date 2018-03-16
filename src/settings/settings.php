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

$settings['hash_salt'] = 'LUYPCPJ1j6J9DbhXIakyw_nwJGJkvmPvTMJCoem41_JWqeQSIJMYIYZk45plByzTEcRVtenSeg';
