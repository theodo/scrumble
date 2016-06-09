angular.module 'Scrumble.indicators'
.controller 'IndicatorsCtrl', (
  $scope
  currentSprint
  Sprint
) ->
  $scope.currentSprint = currentSprint

  $scope.clientSurveyTemplate = currentSprint.project.organization?.satisfactionSurvey
  $scope.checklistsTemplate = currentSprint.project.organization?.checklists

  $scope.saveIndicators = (indicators) ->
    return unless $scope.sprint?
    $scope.sprint.indicators = indicators
    Sprint.save $scope.sprint
