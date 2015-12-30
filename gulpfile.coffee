gulp = require 'gulp'
{spawn} = require 'child_process'
webpack = require 'webpack'

pid = null

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

build = ->
  builder = webpack(require './webpack.config')
  builder.watch {}, (err, stats) ->
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

gulp.task "dev", ->
  build()
  restart()

gulp.watch ["**/*.coffee", "!assets/**/*.coffee", "views/**/*.jade"], {}, ->
  restart()

process.on 'exit', ->
  stopServer()
