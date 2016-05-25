loopback = require 'loopback'
createError = require 'http-errors'

module.exports = (Project) ->

  Project.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    # if ctx.data?
    # TODO: restrict edition to board people

    # new
    ctx.instance?.settings =
      bdcTitle: 'Sprint #{sprintNumber} - {sprintGoal} - Speed {speed}'
    return next()

  Project.getUserProject = (req, next) ->
    Project.app.models.ScrumbleUser.findById(req.accessToken.userId)
    .then (user) ->
      throw new createError.NotFound() unless user?.projectId?
      Project.findById(user.projectId)
    .then (project) ->
      return next(null, project) if project?
      throw new createError.NotFound()
    .catch next

  Project.remoteMethod 'getUserProject',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns:
      type: 'object'
      root: true
    http:
      verb: 'get'
      path: '/current'
