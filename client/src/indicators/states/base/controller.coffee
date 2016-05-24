angular.module 'Scrumble.indicators'
.controller 'IndicatorsCtrl', (
  $scope
  currentSprint
  companies
) ->
  $scope.companies = companies
  $scope.currentSprint = currentSprint

  company = _.find companies, name: $scope.project.settings.company or 'Theodo'
  if company?
    $scope.clientSurveyTemplate = company.satisfactionSurvey
    $scope.checklistsTemplate = company.checklists

  $scope.updateCompany = (name) ->
    $scope.project?.save()
    company = _.find companies, name: name
    if company?
      console.log company
      $scope.clientSurveyTemplate = company.satisfactionSurvey
      $scope.checklistsTemplate = company.checklists

  $scope.saveIndicators = (indicators) ->
    return unless $scope.sprint?
    $scope.sprint.indicators = indicators
    $scope.sprint.save()
