<?php

/**
 * @file
 * Shield settings.
 */

$shields_down = [
  D_ENVIRONMENT_PROD,
  D_ENVIRONMENT_LOCAL,
];

if (in_array(SETTINGS_ENVIRONMENT, $shields_down)) {
  $config['shield.settings']['user'] = '';
  $config['shield.settings']['pass'] = '';
}
else {
  $config['shield.settings']['user'] = 'USER';
  $config['shield.settings']['pass'] = 'PASSWORD';
}
