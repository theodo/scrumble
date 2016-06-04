loopback = require 'loopback'
createError = require 'http-errors'

module.exports = (DailyReport) ->

  DailyReport.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    return next() if ctx.data?

    # new
    DailyReport.app.models.ScrumbleUser.findById(token.userId)
    .then (user) ->
      throw new createError.Unauthorized() unless user?
      ctx.instance.projectId = user.projectId
      next()
    .catch next

  DailyReport.getUserDailyReport = (req, next) ->
    DailyReport.app.models.ScrumbleUser.findById(req.accessToken.userId)
    .then (user) ->
      throw new createError.NotFound() unless user?.projectId?
      DailyReport.findOne
        where:
          projectId: user.projectId
    .then (dailyReport) ->
      return next(null, dailyReport) if dailyReport?
      throw new createError.NotFound()
    .catch next

  DailyReport.remoteMethod 'getUserDailyReport',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true}
    http: { verb: 'get', path: '/current' }
