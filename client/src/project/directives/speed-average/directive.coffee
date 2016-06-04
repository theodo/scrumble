angular.module 'Scrumble.settings'
.directive 'speedAverage', ->
  restrict: 'E'
  templateUrl: 'project/directives/speed-average/view.html'
  scope:
    projectId: '@'
  controller: ($scope, Speed) ->
    Speed.average($scope.projectId)
    .then (averageSpeed) ->
      $scope.average = averageSpeed
