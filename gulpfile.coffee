gulp = require 'gulp'
{spawn} = require 'child_process'

pid = null

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

gulp.task "dev", ->
  restart()
  
gulp.watch ["*.coffee", "views/*.jade"], {}, ->
  restart()

process.on 'exit', ->
  stopServer()
