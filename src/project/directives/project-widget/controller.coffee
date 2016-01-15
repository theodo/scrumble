angular.module 'Scrumble.settings'
.controller 'ProjectWidgetCtrl', ($scope, projectUtils) ->
  $scope.openMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev

  $scope.getRoleLabel = projectUtils.getRoleLabel
