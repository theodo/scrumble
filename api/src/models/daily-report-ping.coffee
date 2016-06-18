loopback = require 'loopback'

module.exports = (DailyReportPing) ->

  DailyReportPing.observe 'before save', (ctx, next) ->
    # update
    if ctx.data?
      ctx.data.updatedAt = new Date()
      return next()

    # new
    ctx.instance.createdAt = new Date()
    return next()
