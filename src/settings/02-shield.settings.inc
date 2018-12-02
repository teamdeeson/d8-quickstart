<?php

/**
 * @file
 * Shield settings.
 */

if (in_array(SETTINGS_ENVIRONMENT, [D_ENVIRONMENT_LOCAL, D_ENVIRONMENT_PROD])) {
  $config['shield.settings']['user'] = '';
  $config['shield.settings']['pass'] = '';
}
else {
  $config['shield.settings']['user'] = 'USER';
  $config['shield.settings']['pass'] = 'PASSWORD';
}
