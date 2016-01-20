angular.module 'Scrumble.indicators'
.controller 'IndicatorsCtrl', ($scope, currentSprint) ->
  $scope.currentSprint = currentSprint
