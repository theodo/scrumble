angular.module 'NotSoShitty.daily-report'
.controller 'DailyReportCtrl', (
  $scope
  mailer
  dailyMail
  DailyMail
  $mdToast
) ->
  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top right')
    .content('Saved!')

  $scope.dailyReport = dailyMail

  $scope.save = ->
    $scope.dailyReport.save().then ->
      $mdToast.show saveFeedback

  $scope.send = ->
    mailer.send $scope.dailyReport, (response) ->
      if response.code > 300
        errorFeedback = $mdToast.simple()
          .hideDelay(3000)
          .position('top right')
          .content("Failed to send message: '#{response.message}'")
        $mdToast.show errorFeedback
      else
        sentFeedback = $mdToast.simple()
          .hideDelay(1000)
          .position('top right')
          .content('Email sent')
        $mdToast.show sentFeedback
      console.log response
