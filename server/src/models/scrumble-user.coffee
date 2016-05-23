request = require 'request'

module.exports = (ScrumbleUser) ->
  unless process.env.TRELLO_KEY?
    console.warn 'The environment variable TRELLO_KEY is undefined. The Trello authentication will not work'

  config =
    TRELLO_KEY: process.env.TRELLO_KEY
    TRELLO_API_ENDPOINT: 'https://api.trello.com/1'

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
        remoteId: trelloInfo.id
      .then (user) ->
        if user?
          authenticate(user).then (token) ->
            return next null, token: token
        else
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

  ScrumbleUser.remoteMethod 'trelloLogin',
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
      verb: 'post'
      path: '/trello-login'
