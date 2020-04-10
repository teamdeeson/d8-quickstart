module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-mixins'),
    require('postcss-nested'),
    require('postcss-custom-media'),
    require('postcss-utilities')({ textHideMethod: 'font' }),
    require('postcss-responsive-type'),
    require('postcss-preset-env')({
      stage: 3,
      autoprefixer: false,
    }),
    require('postcss-inline-svg'),
    require('autoprefixer')({ grid: true }),
  ],
};
