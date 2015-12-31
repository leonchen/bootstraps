path = require 'path'
webpack = require 'webpack'
nodeModules = path.resolve(__dirname, 'node_modules')

VENDORS = [
  'jquery'
  'bootstrap'
  'moment'
  'bluebird'
  'eventemitter2'
  'flux'
  'keymirror'
  'react'
  'react-dom'
  'react-router'
  'superagent'
  'querystring'
]

GLOBAL_VARS =
  $: "jquery"
  jQuery: "jquery"
  moment: "moment"

module.exports =
  entry:
    app: './assets/js/app.cjsx'
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
    new webpack.optimize.UglifyJsPlugin({ compress: { warnings: false } })
  ]
