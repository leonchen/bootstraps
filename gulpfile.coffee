gulp = require 'gulp'
{spawn} = require 'child_process'
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'

config = require './webpack.config'

pid = null
WEBPACK_DEV_SERVER_PORT = 3000

success = (m) ->
  return "\x1b[1;32m#{m}\x1b[0m"
error = (m) ->
  return "\x1b[1;31m#{m}\x1b[0m"
warning = (m) ->
  return "\x1b[1;33m#{m}\x1b[0m"

log = ->
  args = Array.prototype.slice.call arguments
  args.unshift('\x1b[1;32m[gulp]\x1b[0m')
  console.log.apply console, args

stopServer = ->
  return unless pid
  log "killing #{pid}"
  try
    process.kill(pid)
  catch e
    return if e.code == "ESRCH"
    log "failed to kill", e

startServer = ->
  server = spawn "coffee", ["app.coffee"], {env: process.env, stdio: 'inherit'}
  pid = server.pid
  log "starting server with pid #{pid}"
  server.on 'error', ->

restart = ->
  stopServer()
  startServer()

webpackBuildCallback = (err, stats) ->
  log err if err
  s = stats.toJson()
  if s.errors.length > 0
    log error("webpack build failed")
    log s.errors
  else if s.warnings.length > 0
    log warning("webpack build has warnings")
    log s.warnings
  else
    log success("webpack build succeeded")

build = ->
  builder = webpack(config)
  builder.watch {}, webpackBuildCallback

runWebpackDevServer = ->
  serverUrl = "http://127.0.0.1:#{WEBPACK_DEV_SERVER_PORT}"
  process.env.ASSETS_BASE_URL = serverUrl

  config.entry.app.unshift "webpack/hot/dev-server"
  config.entry.app.unshift "webpack-dev-server/client?#{serverUrl}"
  config.output.publicPath = serverUrl + config.output.publicPath
  config.plugins.push new webpack.HotModuleReplacementPlugin()

  builder = webpack(config)
  builder.run webpackBuildCallback
  server = new WebpackDevServer(builder, {publicPath: config.output.publicPath, quiet: true, hot: true})
  server.listen WEBPACK_DEV_SERVER_PORT, "127.0.0.1", (err) ->
    if err
      log error("failed to start webpack dev server")
    else
      log success("webpack dev server started on port #{WEBPACK_DEV_SERVER_PORT}")

gulp.task "dev", ->
  build()
  restart()

gulp.task "hotdev", ->
  runWebpackDevServer()
  restart()


gulp.watch ["**/*.coffee", "!assets/**/*.coffee", "views/**/*.jade"], {}, ->
  restart()

process.on 'exit', ->
  stopServer()
