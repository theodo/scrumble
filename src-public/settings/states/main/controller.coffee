angular.module 'NotSoShitty.settings'
.controller 'SettingsCtrl', (
  $scope
  boards
  TrelloApi
  localStorageService
  UserBoardStorage
  Settings
  settings
) ->
  console.log settings
  # tmp
  token = localStorageService.get 'trello_token'
  if token?
    Trello.setToken token
  $scope.boards = boards

  unless settings?
    settings = new Settings()
    settings.data = {}

  $scope.settings = settings.data
  $scope.settings.resources ?= {}

  # Get board colums and members when board is set
  $scope.$watch 'settings.boardId', (next, prev) ->
    return unless next
    UserBoardStorage.setBoardId next
    TrelloApi.Rest 'GET', 'boards/' + next + '/lists'
    .then (columns) ->
      $scope.boardColumns = columns
    TrelloApi.Rest 'GET', 'boards/' + next + '/members'
    .then (boardMembers) ->
      $scope.boardMembers = boardMembers

  $scope.save = ->
    return unless $scope.settings.boardId?
    settings.boardId = $scope.settings.boardId
    settings.save()
  return
