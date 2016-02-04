angular.module 'Scrumble.indicators'
.controller 'IndicatorsCtrl', (
  $scope
  currentSprint
  companies
) ->
  $scope.companies = companies
  $scope.currentSprint = currentSprint

  $scope.updateCompany = (name) ->
    $scope.company = _.find companies, name: name
    console.log $scope.company

  $scope.selectedCompanyName = currentSprint.indicators?.name

  $scope.saveIndicators = (indicators) ->
    return unless $scope.sprint?
    $scope.sprint.indicators = indicators
    $scope.sprint.save()
