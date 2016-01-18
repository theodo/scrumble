angular.module 'Scrumble.storage'
.factory 'ScrumbleUser', (Parse, $q, TrelloClient, Project, localStorageService) ->
  class NotSoShittyUser extends Parse.Model
    @configure "NotSoShittyUser", "email", "project"

    @getCurrentUser = ->
      @query(
        where:
          email: localStorageService.get 'trello_email'
        include: 'project'
      )
      .then (user) ->
        return if user.length > 0 then user[0] else null
    @getBoardId = ->
      deferred = $q.defer()
      token = localStorageService.get 'trello_token'
      unless token?
        deferred.reject 'No token'

      TrelloClient.get('/member/me')
      .then (response) -> response.data
      .then (userInfo) ->
        UserBoard.query(
          where:
            email: userInfo.email
        )
      .then (userBoards) ->
        if userBoards.length > 0
          deferred.resolve userBoards[0].boardId
        else
          deferred.resolve null
      deferred.promise

    @setBoardId = (boardId) ->
      deferred = $q.defer()
      token = localStorageService.get 'trello_token'
      unless token?
        deferred.reject 'No token'

      TrelloClient.get('/member/me')
      .then (response) -> response.data
      .then (userInfo) ->
        @query(
          where:
            email: userInfo.email
        )
        .then (user) ->
          user = if user.length > 0 then user[0] else null
          if board?
            board.boardId = boardId
            board.save()
          else
            project = new Project()
            project.boardId = boardId

            @project = project
            @save() # todo: check it saves the project
