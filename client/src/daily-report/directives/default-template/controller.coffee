angular.module 'Scrumble.daily-report'
.controller 'DefaultTemplateCtrl', ['$scope', '$mdDialog', 'defaultTemplates', (
  $scope
  $mdDialog
  defaultTemplates
) ->
  $scope.showDialog = (ev) ->
    confirm = $mdDialog.confirm()
    .title 'Example'
    .textContent defaultTemplates.getDefaultTemplate $scope.section
    .ariaLabel 'default-template'
    .targetEvent(ev)
    .ok 'Use in section'
    .cancel 'Cancel'
    .clickOutsideToClose true

    $mdDialog.show(confirm).then ->
      $scope.sections[$scope.section] = defaultTemplates.getDefaultTemplate $scope.section
]