module.exports =
  entry: ["./assets/js/app.cjsx"]

  output:
    path: __dirname + '/public/app/'
    publicPath: '/app/'
    filename: 'bundle.js'

  resolve:
    extensions: ['', '.coffee', '.cjsx', '.jsx', '.js', '.jade', '.json']

  module:
    loaders: [
      {test: /\.coffee$/, loader: "coffee"}
      {test: /\.cjsx$/, loader: "coffee-jsx"}
      {test: /\.jade$/, loader: "jade"}
      {test: /\.json$/, loader: "json"}
      {test: /\.jsx?$/, loader: "babel"}
    ]
