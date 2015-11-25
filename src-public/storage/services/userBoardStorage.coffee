angular.module 'NotSoShitty.storage'
.service 'UserBoardStorage', (UserBoard, localStorageService) ->
  getBoardId: ->
    token = localStorageService.get 'trello_token'
    return null unless token?
    UserBoard.query(
      where:
        token: token
    ).then (userBoards) ->
      if userBoards.length > 0 then userBoards[0].boardId else null

  setBoardId: (boardId) ->
    token = localStorageService.get 'trello_token'
    return null unless token?
    userBoard = new UserBoard()
    userBoard.token = token
    userBoard.boardId = boardId
    userBoard.save()
