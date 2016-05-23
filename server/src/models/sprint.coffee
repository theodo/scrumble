module.exports = (Sprint) ->
  Sprint.getActiveSprint = (req, next) ->
    Sprint.app.models.ScrumbleUser.findById(req.accessToken.userId)
    .then (user) ->
      return next(null, null) unless user?.projectId?
      Sprint.findOne
        where:
          projectId: user.projectId
          isActive: true
      , next

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
