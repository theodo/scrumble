request = require 'request'
_ = require 'lodash'

module.exports = (ScrumbleUser) ->
  unless process.env.TRELLO_KEY?
    console.warn 'The environment variable TRELLO_KEY is undefined. The Trello authentication will not work'

  config =
    TRELLO_KEY: process.env.TRELLO_KEY
    TRELLO_API_ENDPOINT: 'https://api.trello.com/1'
    GOOGLE_API_TOKEN_ENDPOINT: 'https://accounts.google.com/o/oauth2/token'
    GOOGLE_API_SECRET: process.env.GOOGLE_API_SECRET

  authenticate = (scrumbleUser) ->
    ttl = scrumbleUser.constructor.settings.maxTTL
    scrumbleUser.createAccessToken(ttl).then (token) ->
      token.token = token.id

  generatePassword = (length) ->
    characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    result = (characters[Math.floor(Math.random() * characters.length)] for i in [1..length])
    result.join()

  ScrumbleUser.trelloLogin = (req, next) ->
    unless req.body.trelloToken?
      err = new Error 'invalid_request'
      err.message = 'Missing required parameter: trelloToken'
      err.status = 400
      return next err

    request.get
      url: "#{config.TRELLO_API_ENDPOINT}/members/me?key=#{config.TRELLO_KEY}&token=#{req.body.trelloToken}"
      json: true
    , (err, response, trelloInfo) ->
      return next err if err?

      ScrumbleUser.findOne
        where:
          email: trelloInfo.email
      .then (user) ->
        if user? and user.remoteId? # user already connected via loopback
          authenticate(user).then (token) ->
            return next null, token: token
        else if user? # user connected via parse but first time on loopback
          user.remoteId = trelloInfo.id
          user.email = trelloInfo.email
          user.emailverified = trelloInfo.emailverified
          user.username = trelloInfo.username
          user.password = trelloInfo.password
          user.save()
          .then (user) ->
            authenticate(user).then (token) ->
              return next null, token: token
        else # first time for user
          user = new ScrumbleUser
            remoteId: trelloInfo.id
            email: trelloInfo.email
            emailverified: trelloInfo.confirmed
            username: trelloInfo.username
            password: generatePassword 100
          user.save()
          .then (user) ->
            authenticate(user).then (token) ->
              return next null, token: token
      .catch (err) ->
        console.error err
        next err

  fetchGoogleToken = (code, clientId, redirectUri, next) ->
    request.post config.GOOGLE_API_TOKEN_ENDPOINT,
      form:
        code: code
        client_id: clientId
        client_secret: config.GOOGLE_API_SECRET
        redirect_uri: redirectUri
        grant_type: 'authorization_code'
      json: true
    , (err, res, accessToken) ->
      return next(err) if err?
      if res.statusCode isnt 200
        console.error 'access error', accessToken
        return next(accessToken?.error)
      next(null, accessToken)

  ScrumbleUser.googleAuthorization = (req, next) ->
    fetchGoogleToken req.body.code, req.body.clientId, req.body.redirectUri, (error, accessToken) ->
      # TODO: savec accessToken.refresh_token
      next(error, token: accessToken.access_token)

  ScrumbleUser.setProject = (req, next) ->
    unless req.body.projectId?
      return next new createError.BadRequest('Missing required attribute projectId')

    ScrumbleUser.findById(req.accessToken.userId).then (user) ->
      user.projectId = req.body.projectId
      user.save()
    .catch next

  ScrumbleUser.remoteMethod 'trelloLogin',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true }
    http: { verb: 'post', path: '/trello-login' }

  ScrumbleUser.remoteMethod 'googleAuthorization',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true }
    http: { verb: 'post', path: '/auth/google' }

  ScrumbleUser.remoteMethod 'setProject',
    description: 'Set user current project'
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true }
    http: { verb: 'put', path: '/project' }
