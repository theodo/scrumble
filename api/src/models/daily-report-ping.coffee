loopback = require 'loopback'
createError = require 'http-errors'

module.exports = (DailyReportPing) ->

  DailyReportPing.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    if ctx.data?
      ctx.data.updatedAt = new Date()
      return next()

    # new
    ctx.instance.createdAt = new Date()
    return next()
