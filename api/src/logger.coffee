moment = require 'moment'

module.exports =
  log: console.log
  error: console.error
  info: console.info
  warning: console.warn
  logRequest: (req) ->
    console.info "[#{moment().format()}][#{req.method}] #{req.originalUrl}"
