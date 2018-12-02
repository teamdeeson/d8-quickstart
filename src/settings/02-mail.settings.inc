<?php

/**
 * @file
 * E-mail settings.
 */

if (SETTINGS_ENVIRONMENT === D_ENVIRONMENT_PROD) {
  $config['reroute_email.settings']['reroute_email_enable'] = FALSE;
}
else {
  $config['reroute_email.settings']['reroute_email_address'] = 'YOUR_EMAIL@deeson.co.uk';
  $config['reroute_email.settings']['reroute_email_enable'] = TRUE;
  $config['reroute_email.settings']['reroute_email_enable_message'] = TRUE;
}
