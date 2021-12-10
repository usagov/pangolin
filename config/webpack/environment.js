const { environment } = require('@rails/webpacker')

// Place resolve-url-loader into webpack loaders config
// source: https://github.com/rails/webpacker/issues/2155#issuecomment-829741240
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
})

module.exports = environment
