angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  Sprint
) ->
  $scope.form = $scope.sprint?.indicators?.clientSurvey

  $scope.save = ->
    $scope.sprint.indicators =
      clientSurvey: $scope.form
    console.log $scope.sprint
    Sprint.save $scope.sprint
