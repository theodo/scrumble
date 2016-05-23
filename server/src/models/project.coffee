module.exports = (Project) ->

  Project.getUserProject = (req, next) ->
    Project.app.models.ScrumbleUser.findById(req.accessToken.userId)
    .then (user) ->
      return next(null, null) unless user?.projectId?
      Project.findById user.projectId, next

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
