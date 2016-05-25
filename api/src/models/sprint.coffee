createError = require 'http-errors'

module.exports = (Sprint) ->
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
