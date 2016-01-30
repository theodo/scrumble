angular.module 'Scrumble.daily-report'
.controller 'DynamicFieldsModalCtrl', (
  $scope
  $mdDialog
  availableFields
) ->
  $scope.availableFields = availableFields

  $scope.cancel = ->
    $mdDialog.cancel()
