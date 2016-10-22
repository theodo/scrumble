loopback = require 'loopback'
createError = require 'http-errors'
request = require 'request'
_ = require 'lodash'

###
Board Groups allow a user to group boards in order to aggregate project
data (ie Problems). For example a board group can be all the Theodo boards.
Then a user can visualize all the problems of the Theodo boards.

Note: The organization entity in Trello could be used instead but some
Theodo Trello boards are not in the Theodo organization.
###
module.exports = (BoardGroup) ->

  config =
    TRELLO_KEY: process.env.TRELLO_KEY
    TRELLO_API_ENDPOINT: 'https://api.trello.com/1'

  BoardGroup.observe 'before save', (ctx, next) ->
    currentContext = loopback.getCurrentContext()
    return next() unless currentContext?
    token = currentContext?.active?.http?.req?.accessToken

    # update
    if ctx.data?
      ctx.data.userId = token.userId
      ctx.data.updatedAt = new Date()
      return next()

    # new
    ctx.instance.userId = token.userId
    ctx.instance.createdAt = new Date()
    return next()

  BoardGroup.getUserGroups = (req) ->
    BoardGroup.find(where: userId: req.accessToken.userId)

  BoardGroup.getProblems = (req, groupId, next) ->
    # 1. Get group
    BoardGroup.findById(groupId).then (group) ->
      throw new createError.Unauthorized() unless group.userId is req.accessToken.userId

      # 2. Check the user is a member of the boards in the group. Otherwise
      # remove the board
      request.get
        url: "#{config.TRELLO_API_ENDPOINT}/members/me/boards?fields=id,name&key=#{config.TRELLO_KEY}&token=#{req.query.trelloToken}"
        json: true
      , (err, response, trelloInfo) ->
        return next err if err?
        return next(createError.BadRequest(response.body)) if response.statusCode >= 400
        trelloBoardIds = (board.id for board in trelloInfo)
        authorizedBoardIds = _.filter group.boards, (boardId) ->
          boardId in trelloBoardIds

        # 3. for each boards find project and include problems
        BoardGroup.app.models.Project.find
          where:
            boardId:
              inq: authorizedBoardIds
          include:
            problems: 'tags'
        .then (projects) ->
          # 4. Merge problems and for each problem include project object
          aggregatedProblems = _.reduce projects, (problems, project) ->
            projectProblems = _.map project.problems(), (problem) ->
              problem.projectName = project.name
              problem
            _.concat problems, projectProblems
          , []
          next(null, aggregatedProblems)
        .catch next
    return

  BoardGroup.remoteMethod 'getUserGroups',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
    ]
    returns: { type: 'object', root: true}
    http: { verb: 'get', path: '/mine' }

  BoardGroup.remoteMethod 'getProblems',
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
      { arg: 'groupId', type: 'number', http: { source: 'path' } }
    ]
    returns: { type: 'object', root: true}
    http: { verb: 'get', path: '/:groupId/problems' }
