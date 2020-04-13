<?php

/**
 * @file
 * Local development overrides.
 *
 * Include late/last so we can override configuration from other setting files.
 */

use Drupal\Component\Assertion\Handle;

if (SETTINGS_ENVIRONMENT === D_ENVIRONMENT_LOCAL) {
  /*
   * Assertions.
   *
   * The Drupal project primarily uses runtime assertions to enforce the
   * expectations of the API by failing when incorrect calls are made by code
   * under development.
   *
   * @see http://php.net/assert
   * @see https://www.drupal.org/node/2492225
   *
   * If you are using PHP 7.0 it is strongly recommended that you set
   * zend.assertions=1 in the PHP.ini file (It cannot be changed from .htaccess
   * or runtime) on development machines and to 0 in production.
   *
   * @see https://wiki.php.net/rfc/expectations
   */
  assert_options(ASSERT_ACTIVE, TRUE);
  Handle::register();

  /*
   * Enable local development services.
   */
  $settings['container_yamls'][] = dirname(DRUPAL_ROOT) . '/src/services/development.services.yml';

  /*
   * Show all error messages, with backtrace information.
   *
   * In case the error level could not be fetched from the database, as for
   * example the database connection failed, we rely only on this value.
   */
  $config['system.logging']['error_level'] = 'verbose';

  /*
   * Disable CSS and JS aggregation.
   */
  $config['system.performance']['css']['preprocess'] = FALSE;
  $config['system.performance']['js']['preprocess'] = FALSE;

  /*
   * Disable the caches.
   */
  $settings['cache']['bins']['render'] = 'cache.backend.null';
  $settings['cache']['bins']['page'] = 'cache.backend.null';
  $settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';

  /*
   * Allow test modules and themes to be installed.
   *
   * Drupal ignores test modules and themes by default for performance reasons.
   * During development it can be useful to install test extensions for debugging
   * purposes.
   */
  $settings['extension_discovery_scan_tests'] = TRUE;

  /*
   * Enable access to rebuild.php.
   *
   * This setting can be enabled to allow Drupal's php and database cached
   * storage to be cleared via the rebuild.php page. Access to this page can also
   * be gained by generating a query string from rebuild_token_calculator.sh and
   * using these parameters in a request to rebuild.php.
   */
  $settings['rebuild_access'] = TRUE;

  /*
   * Skip file system permissions hardening.
   *
   * The system module will periodically check the permissions of your site's
   * site directory to ensure that it is not writable by the website user. For
   * sites that are managed with a version control system, this can cause problems
   * when files in that directory such as settings.php are updated, because the
   * user pulling in the changes won't have permissions to modify files in the
   * directory.
   */
  $settings['skip_permissions_hardening'] = TRUE;
}
