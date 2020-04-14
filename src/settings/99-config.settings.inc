<?php

/**
 * @file
 * CMI configuration.
 */

/**
 * Location of the site configuration files.
 */
$settings['config_sync_directory'] = '../src/config/sync';

/**
 * Enable local development modules and config
 */
$config['config_split.config_split.local']['status'] = SETTINGS_ENVIRONMENT == D_ENVIRONMENT_LOCAL;
