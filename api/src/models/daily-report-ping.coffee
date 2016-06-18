loopback = require 'loopback'
createError = require 'http-errors'

module.exports = (DailyReportPing) ->

  DailyReportPing.observe 'before save', (ctx, next) ->
    # update
    if ctx.data?
      ctx.data.updatedAt = new Date()
      return next()

    # new
    ctx.instance.createdAt = new Date()
    return next()
