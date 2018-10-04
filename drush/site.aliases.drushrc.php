<?php

/**
 * @file
 * Drush environment aliases drush/sites.aliases.drushrc.php
 */

$aliases['docker'] = array(
  'env' => 'docker',
  'root' => '/var/www/html/docroot',
  'uri' => getenv('D4D_HOSTNAME'),
  'path-aliases' => array(
    '%drush-script' => '/var/www/html/vendor/bin/drush',
  ),
);
