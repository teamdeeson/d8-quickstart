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
  'env' => 'docker',
  'uri' => 'localhost',
  'root' => '/var/www/html/docroot',
  // Drush ignores the remote-host and does not attempt an SSH connection if
  // the value is localhost or 127.0.0.1.
  // This is incorrect.
  // We can work around this by using any DNS entry which resolves to
  // 127.0.0.1 such as localtest.me.
  // You should add an entry to your hosts file such as the following, and
  // replace the localtest.me hostname:
  // 127.0.0.1 docker.local
  // 'remote-host' => 'docker.local',
  'remote-host' => 'localtest.me',
  'remote-user' => 'www-data',
  'ssh-options' => '-p 2223',
  'path-aliases' => array(
    '%drush-script' => '/var/www/html/vendor/bin/drush',
  ),
);
