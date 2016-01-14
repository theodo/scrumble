angular.module 'NotSoShitty.login'
.controller 'TrelloLoginCtrl', (
  $scope
  $rootScope
  TrelloClient
  $state
  $auth
  NotSoShittyUser
  localStorageService
) ->
  $scope.doing = false

  $scope.login = ->
    $scope.doing = true
    TrelloClient.authenticate()
    .then (response) -> TrelloClient.get('/member/me')
    .then (response) -> response.data
    .then (userInfo) ->
      localStorageService.set 'trello_email', userInfo.email
    .then ->
      NotSoShittyUser.getCurrentUser()
    .then (user) ->
      unless user?
        user = new NotSoShittyUser()
        user.email = localStorageService.get 'trello_email'
        user.save()
    .then ->
      $state.go 'tab.board'
