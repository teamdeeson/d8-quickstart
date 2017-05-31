<?php

/**
 * @file
 * Drush environment aliases drush/sites.aliases.drushrc.php
 */

if (!isset($drush_major_version)) {
  $drush_version_components = explode('.', DRUSH_VERSION);
  $drush_major_version = $drush_version_components[0];
}

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
  'php' => dirname(dirname(__FILE__)) . '/scripts/docker-drush-launcher.sh',
  'root' => '/var/www/html/docroot',
);
