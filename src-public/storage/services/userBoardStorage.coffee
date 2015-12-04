angular.module 'NotSoShitty.storage'
.service 'UserBoardStorage', (UserBoard, User, localStorageService) ->
  getBoardId = ->
    token = localStorageService.get 'trello_token'
    return null unless token?
    User.getTrelloInfo().then (userInfo) ->
      UserBoard.query(
        where:
          email: userInfo.email
      )
    .then (userBoards) ->
      if userBoards.length > 0 then userBoards[0].boardId else null

  setBoardId = (boardId) ->
    token = localStorageService.get 'trello_token'
    return null unless token?
    User.getTrelloInfo().then (userInfo) ->
      UserBoard.query(
        where:
          email: userInfo.email
      )
      .then (userBoards) ->
        board = if userBoards.length > 0 then userBoards[0] else null
        if board?
          board.boardId = boardId
          board.save()
        else
          userBoard = new UserBoard()
          userBoard.email = userInfo.email
          userBoard.boardId = boardId
          userBoard.save()


  getBoardId: getBoardId
  setBoardId: setBoardId
