angular.module 'Scrumble.settings'
.directive 'speedInfo', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    projectId: '@'
  controller: ($scope, Speed) ->
    Speed.formattedSpeedInfo($scope.projectId)
    .then (formattedSpeedInfo) ->
      $scope.info = formattedSpeedInfo
