angular.module 'Scrumble.daily-report'
.controller 'DefaultTemplateCtrl', (
  $scope
  defaultTemplates
) ->
  $scope.setDefault = ->
    $scope.sections[$scope.section] = defaultTemplates.getDefaultTemplate $scope.section
