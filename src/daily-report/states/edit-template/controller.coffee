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
  $scope.availableFields1 = dynamicFields.getAvailableFields()[..6]
  $scope.availableFields2 = _.union(
    dynamicFields.getAvailableFields()[7..]
    reportBuilder.getAvailableFields()
  )

  $scope.save = ->
    $scope.dailyReport.save().then ->
      $mdToast.show saveFeedback
