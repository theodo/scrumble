angular.module 'Scrumble.settings'
.controller 'MemberFormCtrl', ($scope, projectUtils) ->
  $scope.daily = projectUtils.getDailyRecipient()
  $scope.roles = projectUtils.getRoles()
