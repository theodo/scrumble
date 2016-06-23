angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  loadingToast
  Sprint
) ->
  _.forEach $scope.sprint.indicators.satisfactionSurvey, (question, index) ->
    $scope.template[index].answer = question.answer

  $scope.save = ->
    loadingToast.show()
    $scope.saving = true
    $scope.sprint.indicators ?= {}
    $scope.sprint.indicators.satisfactionSurvey = $scope.template
    Sprint.save $scope.sprint
    .then ->
      loadingToast.hide()
      $scope.saving = false

  $scope.saveInSpreadsheet = ->
    return

  $scope.print = ->
    window.print()
