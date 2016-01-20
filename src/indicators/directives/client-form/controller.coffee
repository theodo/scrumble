angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  Sprint
  loadingToast
) ->
  $scope.form = $scope.sprint?.indicators?.clientSurvey

  $scope.save = ->
    loadingToast.show()
    $scope.saving = true
    $scope.sprint.indicators =
      clientSurvey: $scope.form
    Sprint.save $scope.sprint
    .then ->
      loadingToast.hide()
      $scope.saving = false

  $scope.print = ->
    window.print()
