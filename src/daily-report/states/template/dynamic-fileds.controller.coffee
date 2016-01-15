angular.module 'Scrumble.daily-report'
.controller 'DynamicFieldsModalCtrl', (
  $scope
  $mdDialog
  availableFields
  dailyReport
) ->
  $scope.availableFields = availableFields
  $scope.dailyReport = dailyReport

  $scope.hide = ->
    $mdDialog.hide()
  $scope.cancel = ->
    $mdDialog.cancel()
  $scope.save = ->
    dailyReport.save().then ->
      $mdDialog.hide()
