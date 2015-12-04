angular.module 'NotSoShitty.login'
.controller 'LoginCtrl', (
  $scope
  $rootScope
  TrelloClient
  $state
  $auth
) ->
  if $auth.isAuthenticated()
    $state.go 'settings'
  $scope.login = ->
    TrelloClient.authenticate().then ->
      $rootScope.$broadcast 'refresh-profil'
      $state.go 'settings'
