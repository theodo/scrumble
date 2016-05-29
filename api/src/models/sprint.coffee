loopback = require 'loopback'
createError = require 'http-errors'
_ = require 'lodash'

module.exports = (Sprint) ->
  checkDates = (sprint) ->
    if sprint?.bdcData?
      # check start/end date consistency
      if _.isArray(sprint?.dates?.days) and sprint?.dates?.days.length > 0
        [first, ..., last] = sprint.dates.days
        sprint.dates.start = first.date
        sprint.dates.end = last.date
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
    .then (sprint) ->
      return next(null, sprint) if sprint
      throw new createError.NotFound()
    .catch next

  Sprint.remoteMethod 'getActiveSprint',
    accepts: [
      {
        arg: 'req'
        type: 'object'
        http:
          source: 'req'
      }
    ]
    returns:
      type: 'object'
      root: true
    http:
      verb: 'get'
      path: '/active'
