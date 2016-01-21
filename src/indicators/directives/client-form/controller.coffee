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
    loadingToast.show()
    $scope.saving = true
    $scope.sprint.indicators =
      satisfactionSurvey: $scope.survey
    Sprint.save $scope.sprint
    .then ->
      loadingToast.hide()
      $scope.saving = false

  $scope.print = ->
    window.print()
