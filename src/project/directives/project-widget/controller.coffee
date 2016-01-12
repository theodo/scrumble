angular.module 'NotSoShitty.settings'
.controller 'ProjectWidgetCtrl', ($scope, projectUtils) ->
  $scope.openMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev

  roles = projectUtils.getRoles()
  $scope.getRoleLabel = (key) ->
    result = _.find roles, (role) ->
      role.value is key
    result?.label
