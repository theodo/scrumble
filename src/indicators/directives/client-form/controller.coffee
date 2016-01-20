angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  Sprint
) ->
  $scope.form = $scope.sprint?.indicators?.clientSurvey

  $scope.save = ->
    $scope.sprint.indicators =
      clientSurvey: $scope.form
    Sprint.save $scope.sprint

  $scope.print = ->
    window.print()
