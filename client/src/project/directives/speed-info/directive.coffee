angular.module 'Scrumble.settings'
.directive 'speedInfo', ->
  restrict: 'E'
  templateUrl: 'project/directives/speed-info/view.html'
  scope:
    projectId: '@'
  controller: ($scope, Speed) ->

    Speed.formattedSpeedInfo($scope.projectId)
    .then (formattedSpeedInfo) ->
      $scope.info = formattedSpeedInfo
