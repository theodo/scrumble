angular.module 'Scrumble.daily-report'
.controller 'EditTemplateCtrl', (
  $scope
  $mdToast
  mailer
  reportBuilder
  dailyReport
  dynamicFields
) ->
  reportBuilder.init()

  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top right')
    .content('Saved!')

  $scope.dailyReport = dailyReport
  $scope.availableFields = _.union(
    dynamicFields.getAvailableFields()
    reportBuilder.getAvailableFields()
  )

  $scope.save = ->
    $scope.dailyReport.save().then ->
      $mdToast.show saveFeedback
