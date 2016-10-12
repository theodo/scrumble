loopback = require 'loopback'

module.exports = (BoardGroup) ->

  BoardGroup.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    if ctx.data?
      ctx.data.userId = token.userId
      ctx.data.updatedAt = new Date()
      return next()

    # new
    ctx.instance.userId = token.userId
    ctx.instance.createdAt = new Date()
    return next()

  BoardGroup.getUserGroups = (req) ->
    BoardGroup.find(where: userId: req.accessToken.userId)

  BoardGroup.remoteMethod 'getUserGroups',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true}
    http: { verb: 'get', path: '/mine' }
