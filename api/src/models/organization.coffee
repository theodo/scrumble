module.exports = (Organization) ->
  return
  # Organization.getProblems = (req, next) ->
  #   Organization.app.models.ScrumbleUser.findById(req.accessToken.userId)
  #   .then (user) ->
  #     throw new createError.NotFound() unless user?.projectId?
  #     Project.findById(user.projectId)
  #   .then (project) ->
  #     return next(null, project) if project?
  #     throw new createError.NotFound()
  #   .catch next
  #   return
  #
  # Organization.remoteMethod 'getProblems',
  #   accepts: [
  #     { arg: 'organizationId', type: 'number', http: { source: 'path' } }
  #   ]
  #   returns: { type: 'array', root: true}
  #   http: { verb: 'get', path: '/:organizationId/problems' }
