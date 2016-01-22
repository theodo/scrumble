angular.module 'Scrumble.indicators'
.controller 'IndicatorsCtrl', (
  $scope
  currentSprint
  satisfactionSurveyTemplates
) ->
  $scope.currentSprint = currentSprint
  $scope.satisfactionSurveyTemplates = satisfactionSurveyTemplates
