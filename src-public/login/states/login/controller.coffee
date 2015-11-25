angular.module 'NotSoShitty.login'
.controller 'LoginCtrl', (
  $scope
  TrelloApi
  $state
) ->
  $scope.login = ->
    TrelloApi.Authenticate().then ->
      $state.go 'settings'
