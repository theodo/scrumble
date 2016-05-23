module.exports = (server) ->

  Role = server.models.Role

  Role.isAdmin = (token, next) ->
    return next(null, false) unless token?
    server.models.ScrumbleUser.find
      where:
        email:
          inq: ['nicolasg@theodo.fr']
    .then (admins) ->
      return next(null, token.userId in (admin.id for admin in admins))
    .catch next

  Role.registerResolver 'admin', (role, context, next) ->
    Role.isAdmin(context?.accessToken, next)
