angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  loadingToast
  Sprint
) ->
  if _.isArray $scope.sprint?.indicators?.satisfactionSurvey
    for question, index in $scope.sprint.indicators.satisfactionSurvey
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
