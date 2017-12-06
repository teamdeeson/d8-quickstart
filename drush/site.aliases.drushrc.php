<?php

/**
 * @file
 * Drush environment aliases drush/sites.aliases.drushrc.php
 */

// VDD.
$aliases['vdd'] = array(
  'env' => 'vdd',
  'uri' => 'PROJECT.dev',
  'root' => '/var/www/vhosts/PROJECT.dev/docroot',
  'path-aliases' => array(
    '%drush-script' => '/var/www/vhosts/PROJECT.dev/vendor/bin/drush',
  ),
);

if (!file_exists('/var/www/vhosts/PROJECT.dev/docroot')) {
  $aliases['vdd']['remote-host'] = 'dev.local';
  $aliases['vdd']['remote-user'] = 'vagrant';
}

$aliases['docker'] = array(
  'env' => 'docker',
  'uri' => 'localhost',
  'root' => '/var/www/html/docroot',
  'path-aliases' => array(
    '%drush-script' => '/var/www/html/vendor/bin/drush',
  ),
);
