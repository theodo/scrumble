angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  Sprint
  loadingToast
  defaultSatisfactionForm
) ->
  if $scope.sprint?.indicators?.satisfactionSurvey?
    $scope.survey = $scope.sprint?.indicators?.satisfactionSurvey
  else
    $scope.survey = angular.copy defaultSatisfactionForm

  $scope.save = ->
    $scope.sprint.indicators =
      satisfactionSurvey: $scope.survey
    Sprint.save $scope.sprint

  $scope.print = ->
    window.print()
