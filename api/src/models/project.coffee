loopback = require 'loopback'
createError = require 'http-errors'
_ = require 'lodash'

module.exports = (Project) ->

  Project.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    # if ctx.data?
    # TODO: restrict edition to board people
    return next() if ctx.data?

    # new
    ctx.instance?.settings =
      bdcTitle: 'Sprint #{sprintNumber} - {sprintGoal} - Speed {speed}'
    return next()

  Project.getUserProject = (req, next) ->
    next('yolo')
    Project.app.models.ScrumbleUser.findById(req.accessToken.userId)
    .then (user) ->
      throw new createError.NotFound() unless user?.projectId?
      Project.findById(user.projectId)
    .then (project) ->
      return next(null, project) if project?
      throw new createError.NotFound()
    .catch next

  Project.getLastSpeeds = (projectId, next) ->
    Project.app.models.Sprint.find(
      where:
        projectId: projectId
      order: 'number DESC'
      limit: 3
    ).then (sprints) ->
      next(null, _.map(sprints, (sprint) ->
        speed: sprint.resources?.speed
        sprintNumber: sprint.number
      ))
    .catch next

  Project.remoteMethod 'getUserProject',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true}
    http: { verb: 'get', path: '/current' }

  Project.remoteMethod 'getLastSpeeds',
    accepts: [
      { arg: 'projectId', type: 'number', http: { source: 'path' } }
    ]
    returns: { type: 'array', root: true}
    http: { verb: 'get', path: '/:projectId/last-speeds' }
