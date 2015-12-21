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
  if localStorageService.get 'trello_token'
    $state.go 'tab.current-sprint'
  $scope.login = ->
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
      # $rootScope.$broadcast 'refresh-profil'
      $state.go 'tab.project'
