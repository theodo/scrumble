angular.module 'NotSoShitty.settings'
.controller 'SettingsCtrl', (
  $scope
  boards
  TrelloClient
  localStorageService
  UserBoardStorage
  $mdToast
  Settings
  settings
) ->
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
    TrelloClient.get('/boards/' + next + '/lists')
    .then (response) ->
      $scope.boardColumns = response.data
    TrelloClient.get('/boards/' + next + '/members?fields=avatarHash,fullName,initials,username')
    .then (response) ->
      $scope.boardMembers = response.data

  $scope.save = ->
    return unless $scope.settings.boardId?
    settings.boardId = $scope.settings.boardId
    saveFeedback = $mdToast.simple()
      .hideDelay(1000)
      .position('top right')
      .content('Saved!')
    settings.save().then ->
      $mdToast.show saveFeedback
  return
