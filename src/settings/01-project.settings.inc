<?php

/**
 * @file
 * Project specific settings.
 */

// GA code.
if (SETTINGS_ENVIRONMENT === 'prod') {
  // @todo: Fill in client/project GA code.
  $config['google_analytics']['account'] = 'UA-';
}
else {
  // Disable GA tracking on local and test environments.
  $config['google_analytics']['account'] = '';
}
