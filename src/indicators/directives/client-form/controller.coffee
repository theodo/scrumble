angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  Sprint
  loadingToast
  defaultSatisfactionForm
) ->
  if $scope.sprint?.indicators?.clientSurvey?
    $scope.survey = $scope.sprint?.indicators?.clientSurvey
  else
    $scope.survey = angular.copy defaultSatisfactionForm

  $scope.save = ->
    $scope.sprint.indicators =
      clientSurvey: $scope.survey
    Sprint.save $scope.sprint

  $scope.print = ->
    window.print()
