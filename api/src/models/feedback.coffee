loopback = require 'loopback'
Promise = require 'bluebird'
logger = require '../logger'

module.exports = (Feedback) ->
  Feedback.disableRemoteMethod 'deleteById', true

  Feedback.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    if ctx.data?
      ctx.data.updatedAt = new Date()
      return next()

    # new
    ctx.instance.createdAt = new Date()
    if token?.userId?
      userPromise = Feedback.app.models.ScrumbleUser.findById(token.userId)
    else
      userPromise = Promise.resolve(null)

    userPromise.then (user) ->
      ctx.instance.reporter = user?.email
      logger.email "New Scrumble Feedback from #{ctx.instance.reporter}", ctx.instance.message, -> return
