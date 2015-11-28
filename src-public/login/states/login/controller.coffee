angular.module 'NotSoShitty.login'
.controller 'LoginCtrl', (
  $scope
  TrelloClient
  $state
  $auth
) ->
  if $auth.isAuthenticated()
    $state.go 'settings'
  $scope.login = ->
    TrelloClient.authenticate().then ->
      $state.go 'settings'
