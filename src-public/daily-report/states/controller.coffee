angular.module 'NotSoShitty.daily-report'
.controller 'DailyReportCtrl', ($scope, dailyMail, DailyMail, $mdToast) ->
  $scope.dailyReport = dailyMail

  $scope.save = ->
    saveFeedback = $mdToast.simple()
      .hideDelay(1000)
      .position('top right')
      .content('Saved!')
    $scope.dailyReport.save().then ->
      $mdToast.show saveFeedback
  return
