<?php

/**
 * @file
 * Caching settings.
 */

/**
 * Enables Redis cache service.
 *
 * Set to TRUE if the Redis module is present AND enabled, and the Redis service is available.
 */
define('CACHE_ENABLE_REDIS', FALSE);
/**
 * Enables Memcache cache service.
 *
 * Set to TRUE if the Memcache service is available.
 */
define('CACHE_ENABLE_MEMCACHE', FALSE);

if (SETTINGS_ENVIRONMENT != D_ENVIRONMENT_LOCAL) {
  if (CACHE_ENABLE_REDIS) {
    $settings['redis.connection']['interface'] = 'PhpRedis';

    $settings['cache']['default'] = 'cache.backend.redis';
    // Always set the fast backend for bootstrap, discover and config, otherwise
    // this gets lost when redis is enabled.
    $settings['cache']['bins']['bootstrap'] = 'cache.backend.chainedfast';
    $settings['cache']['bins']['discovery'] = 'cache.backend.chainedfast';
    $settings['cache']['bins']['config'] = 'cache.backend.chainedfast';

    $settings['container_yamls'][] = 'modules/contrib/redis/example.services.yml';
  }
  if (CACHE_ENABLE_MEMCACHE) {
    // @todo Memcache integration.
  }

}

if (in_array(SETTINGS_ENVIRONMENT, [D_ENVIRONMENT_TEST, D_ENVIRONMENT_PROD])) {
  $config['system.performance']['css']['gzip'] = TRUE;
  $config['system.performance']['css']['preprocess'] = TRUE;

  $config['system.performance']['js']['gzip'] = TRUE;
  $config['system.performance']['js']['preprocess'] = TRUE;
}
