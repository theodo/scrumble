loopback = require 'loopback'
boot = require 'loopback-boot'
logger = require './logger'

app = loopback()

app.start = ->
  # start the web server
  app.listen ->
    app.emit 'started'
    logger.log 'Web server listening at: %s', app.get 'url'

app.use (req, res, next) ->
  # Hereafter, we log all the requests to the functional log stream
  # logger.log req, res
  next()

app.use loopback.token
  model: app.models.accessToken
  currentUserLiteral: 'me'

# Bootstrap the application, configure models, datasources and middleware.
# Sub-apps like REST API are mounted via boot scripts.
boot app, __dirname, (err) ->
  throw err if err
  require('loopback-promisify')(app)
  app.start() if require.main == module
  return

module.exports = app
