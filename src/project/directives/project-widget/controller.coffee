angular.module 'NotSoShitty.settings'
.controller 'ProjectWidgetCtrl', ($scope) ->
  console.log $scope.project
  $scope.openMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev
