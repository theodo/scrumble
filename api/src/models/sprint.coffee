loopback = require 'loopback'
createError = require 'http-errors'
_ = require 'lodash'
moment = require 'moment'

module.exports = (Sprint) ->
  Sprint.disableRemoteMethod 'find', true
  checkDates = (sprint) ->
    if sprint?.bdcData?
      # check start/end date consistency
      if _.isArray(sprint?.dates?.days) and sprint?.dates?.days.length > 0
        [first, ..., last] = sprint.dates.days
        sprint.dates.start = moment(first.date).toISOString()
        sprint.dates.end = moment(last.date).toISOString()
      else
        if sprint?
          sprint.dates.start = null
          sprint.dates.end = null
    sprint

  Sprint.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    if ctx.data?
      checkDates ctx.data
      # TODO: restrict edition to board people
      return next()

    # new
    checkDates ctx.instance
    Sprint.updateAll({ projectId: ctx.instance.projectId }, { isActive: false })
    .then ->
      ctx.instance.settings =
        bdcTitle: 'Sprint #{sprintNumber} - {sprintGoal} - Speed {speed}'
      ctx.instance.isActive = true
      return next()

    return

  Sprint.getActiveSprint = (req, next) ->
    Sprint.app.models.ScrumbleUser.findById(req.accessToken.userId)
    .then (user) ->
      throw new createError.NotFound() unless user?.projectId?
      Sprint.findOne
        where:
          projectId: user.projectId
          isActive: true
        include: [
          'project'
        ]
    .then (sprint) ->
      return next(null, sprint) if sprint
      throw new createError.NotFound()
    .catch next
    return

  Sprint.activate = (req, sprintId, next) ->
    Sprint.app.models.ScrumbleUser.findById(req.accessToken.userId)
    .then (user) ->
      throw new createError.NotFound() unless user?.projectId?
      Sprint.findById(sprintId)
      .then (sprint) ->
        throw new createError.Unauthorized() unless user?.projectId is sprint.projectId
        sprint
    .then (sprint) ->
      Sprint.updateAll({ projectId: sprint.projectId }, { isActive: false })
      .then ->
        sprint.isActive = true
        Sprint.upsert sprint, (err) ->
          next err, 'OK'
    .catch next
    return

  Sprint.remoteMethod 'getActiveSprint',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true }
    http: { verb: 'get', path: '/active' }

  Sprint.remoteMethod 'activate',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
      { arg: 'sprintId', type: 'number', http: { source: 'path' } }
    ]
    returns: { type: 'string', root: true }
    http: { verb: 'put', path: '/:sprintId/activate' }
