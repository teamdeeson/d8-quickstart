const config = require('deeson-webpack-config-starter');

// this should be the real asset path in drupal
// so something like /sites/all/themes/blah_blah/assets
config.output.publicPath = '/themes/custom/component_theme/assets';

delete config.entry.pages;
config.devServer.inline = false;

module.exports = config;
