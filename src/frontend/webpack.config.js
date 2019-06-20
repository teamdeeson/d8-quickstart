const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const WriteFilePlugin = require('write-file-webpack-plugin');
const DrupalTemplatePlugin = require('deeson-webpack-config-starter/drupal-templates-webpack-plugin');

const path = require('path');

const config = {
  entry: {
    app: './src/app.js',
  },
  mode: 'development',
  devtool: '#source-map',
  output: {
    path: path.resolve(process.cwd(), 'assets'),
    publicPath: '/themes/custom/component_theme/assets',
    filename: '[name].js',
  },
  devServer: {
    inline: false,
    quiet: false,
    noInfo: false,
    https: true,
    stats: {
      assets: false,
      colors: true,
      version: false,
      hash: false,
      timings: false,
      chunks: false,
      chunkModules: false,
    },
    proxy: {
      '*': {
        target: 'http://localhost:3000',
        secure: false,
      },
    },
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules)/,
        loader: 'babel-loader',
      },
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          { loader: 'css-loader', options: { sourceMap: true } },
          { loader: 'postcss-loader', options: { sourceMap: true } },
        ],
      },
      {
        issuer: /\.css/,
        test: /.*\.(gif|png|jpe?g|svg)(\?v=\d+\.\d+\.\d+)?$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 1000,
              name: '[path][name].[ext]',
              context: 'src',
            },
          },
        ],
      },
      {
        issuer: { exclude: /\.css/ },
        test: /.*\.(gif|png|jpe?g|svg)(\?v=\d+\.\d+\.\d+)?$/i,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[path][name].[ext]',
              context: 'src',
            },
          },
        ],
      },
      {
        test: /\.(tpl\.php|html\.twig)$/,
        loader: 'file-loader',
        options: { regExp: '.*/src/(.*)', name: '[1]' },
        exclude: [/pages/],
      },
      {
        test: /(\.php|\.twig|\.twig\.html)$/,
        loader: 'file-loader',
        options: { name: 'pages/[name].[ext]' },
        exclude: [/src/],
      },

      { test: /\.eot(\?v=\d+\.\d+\.\d+)?$/, loader: 'file-loader' },
      { test: /\.(woff|woff2)$/, loader: 'url-loader', options: { prefix: 'font/', limit: 5000 } },
      {
        test: /\.[ot]tf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader',
        options: { limit: 10000, mimetype: 'application/octet-stream' },
      },
    ],
  },
  plugins: [
    new WriteFilePlugin({ log: false }),
    new DrupalTemplatePlugin({ ignore: /.*pages.*/ }),
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // both options are optional
      filename: '[name].css',
      chunkFilename: '[id].css',
    }),
  ],
};

if (typeof process.env.DOCKER_LOCAL !== 'undefined' && process.env.DOCKER_LOCAL === '1') {
  config.devServer.host = '0.0.0.0';
  config.devServer.port = 80;
  config.devServer.https = false;
  config.devServer.disableHostCheck = true;
  config.devServer.proxy['*'].target = 'http://fe-php:80';
  config.watchOptions = config.watchOptions || {};
  config.watchOptions.poll = 1000;
}

module.exports = config;
