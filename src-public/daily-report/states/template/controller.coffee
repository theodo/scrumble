angular.module 'NotSoShitty.daily-report'
.controller 'DailyReportCtrl', (
  $scope
  $mdToast
  $mdDialog
  $mdMedia
  mailer
  reportBuilder
  dailyReport
) ->

  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top right')
    .content('Saved!')

  $scope.dailyReport = dailyReport

  $scope.save = ->
    $scope.dailyReport.save().then ->
      $mdToast.show saveFeedback

  $scope.preview = (ev) ->
    $mdDialog.show
      controller: 'PreviewCtrl'
      templateUrl: 'daily-report/states/preview/view.html'
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: $mdMedia 'sm'
      resolve:
        message: ->
          reportBuilder.dateFormat $scope.dateFormat
          reportBuilder.render $scope.dailyReport.message
