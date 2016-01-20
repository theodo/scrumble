angular.module 'Scrumble.indicators'
.controller 'PrintClientSurveyCtrl', (
  $scope
  $timeout
  sprint
) ->
  $scope.sprint = sprint

  $timeout ->
    window.print()
  , 500
