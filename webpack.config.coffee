path = require 'path'
webpack = require 'webpack'
nodeModules = path.resolve(__dirname, 'node_modules')

VENDORS = [
  'moment'
  'bluebird'
  'eventemitter2'
  'keymirror'
  'superagent'
  'querystring'
  'react'
  'react-dom'
  'react-router'
  'flux'
]

GLOBAL_VARS =
  moment: "moment"

config =
  entry:
    app: ['./assets/js/app.cjsx']
    vendor: VENDORS

  output:
    path: __dirname + '/public/js/'
    publicPath: '/js/'
    filename: '[name].js'
    chunkFilename: '[name].js'

  resolve:
    extensions: ['', '.coffee', '.cjsx', '.jsx', '.js', '.jade', '.json']

  module:
    loaders: [
      {test: /\.coffee$/, loader: "coffee"}
      {test: /\.cjsx$/, loader: "coffee-jsx"}
      {test: /\.css$/, loader: "style!css"}
      {test: /\.jade$/, loader: "jade"}
      {test: /\.json$/, loader: "json"}
      {test: /\.jsx$/, loader: "babel"}
      {test: /\.js$/, exclude: [nodeModules], loader: "babel"}
      {test: /\.(ttf|eot|svg|woff(2)?|png|jpg|gif)(\?[a-z0-9]+)?$/, loader: 'file-loader'}
    ]

  plugins: [
    new webpack.ProvidePlugin(GLOBAL_VARS)
  ]

# deployments
if process.env.DEPLOY
  config.plugins.push new webpack.optimize.UglifyJsPlugin({sourceMap: false, compress: { warnings: false } })

module.exports = config
