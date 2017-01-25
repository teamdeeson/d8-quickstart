<?php

/**
 * @file
 * Shield settings.
 */

if (in_array(SETTINGS_ENVIRONMENT, ['local', 'live'])) {
  $config['shield.settings']['user'] = '';
  $config['shield.settings']['pass'] = '';
}
else {
  $config['shield.settings']['user'] = 'USER';
  $config['shield.settings']['pass'] = 'PASSWORD';
}
