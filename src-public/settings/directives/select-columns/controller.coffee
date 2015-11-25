angular.module 'NotSoShitty.settings'
.controller 'SelectColumnsCtrl',
($scope) ->
  $scope.listTypes = [
    'backlog'
    'sprintBacklog'
    'doing'
    'blocked'
    'toValidate'
    'done'
  ].reverse()

  $scope.columnIds ?= {}
