angular.module 'NotSoShitty.settings'
.controller 'ProjectWidgetCtrl', ($scope) ->
  $scope.openMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev
