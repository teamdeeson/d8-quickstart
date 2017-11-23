<?php

namespace DrupalProject\composer;

use Composer\Script\Event;
use Symfony\Component\Filesystem\Filesystem;

/**
 * Class DeesonScriptHandler
 *
 * @package DrupalProject\composer
 */
class DeesonScriptHandler {

  /**
   * @param \Composer\Script\Event $event
   *   The event.
   */
  public static function createRequiredFiles(Event $event) {
    $fs = new Filesystem();
    $project_root = getcwd();
    $drupal_root = static::getDrupalRoot($project_root);

    // Create a web symlink.
    if (!$fs->exists($project_root . '/web')) {
      $fs->symlink('docroot', $project_root . '/web');
    }

    $dirs = [
      'modules',
      'profiles',
      'themes',
    ];

    // Required for unit testing.
    foreach ($dirs as $dir) {
      if (!$fs->exists($drupal_root . '/' . $dir)) {
        $fs->mkdir($drupal_root . '/' . $dir);
        $fs->touch($drupal_root . '/' . $dir . '/.gitkeep');
      }
    }

    $links = [
      'src/modules' => 'modules/custom',
      'src/themes' => 'themes/custom',
      'src/profiles' => 'profiles/custom',
    ];

    // Create symlinks within the docroot.
    foreach ($links as $src => $dest) {
      $fs->symlink('../../' . $src, $drupal_root . '/' . $dest);
    }

    // Link drush/ to docroot/drush/.
    if (!$fs->exists($drupal_root . '/drush')) {
      $fs->symlink('../drush', $drupal_root . '/drush');
      $event->getIO()->write("Created a symlink for drush/");
    }

    // Prepare the settings file.
    if (!$fs->exists($drupal_root . '/sites/default/settings.php')) {
      $fs->symlink('../../../src/settings/settings.php', $drupal_root . '/sites/default/settings.php');
      $event->getIO()
        ->write("Created a symlink for sites/default/settings.php");
    }

    // Create the files directory with chmod 0777.
    if (!$fs->exists($drupal_root . '/sites/default/files')) {
      $oldmask = umask(0);
      $fs->mkdir($drupal_root . '/sites/default/files', 0777);
      umask($oldmask);
      $event->getIO()
        ->write("Created a sites/default/files directory with chmod 0777");
    }
  }

  /**
   * @param string $project_root
   *   The project root directory path.
   * @return string
   *   The drupal root directory path.
   */
  protected static function getDrupalRoot($project_root) {
    return $project_root . '/docroot';
  }

}
