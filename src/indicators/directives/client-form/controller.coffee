angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  Sprint
  loadingToast
) ->
  if $scope.sprint?.indicators?.clientSatisfaction?
    $scope.survey = $scope.sprint?.indicators?.clientSatisfaction
  else
    $scope.survey = _.find $scope.templates, company: 'Theodo'
  $scope.save = ->
    loadingToast.show()
    $scope.saving = true
    $scope.sprint.indicators =
      clientSatisfaction: $scope.survey
    Sprint.save $scope.sprint
    .then ->
      loadingToast.hide()
      $scope.saving = false

  $scope.print = ->
    window.print()
