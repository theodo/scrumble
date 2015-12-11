angular.module 'NotSoShitty.daily-report'
.controller 'DailyReportCtrl', (
  $scope
  mailer
  dailyReport
  $mdToast
) ->
  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top right')
    .content('Saved!')

  $scope.dailyReport = dailyReport

  $scope.save = ->
    $scope.dailyReport.save().then ->
      $mdToast.show saveFeedback

  $scope.send = ->
    mailer.send $scope.dailyReport.message, (response) ->
      if response.code? and response.code > 300
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
