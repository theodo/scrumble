angular.module 'Scrumble.daily-report'
.controller 'PreviewCtrl', (
  $scope
  $sce
  $mdDialog
  $mdToast
  googleAuth
  mailer
  message
  reportBuilder
  dailyReport
  todaysGoals
) ->
  $scope.message = message

  $scope.trustAsHtml = (string) ->
    $sce.trustAsHtml string

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.login = ->
    googleAuth.login().then ->
      googleAuth.isAuthenticated().then (isAuthenticated) ->
        $scope.isAuthenticated = isAuthenticated
  googleAuth.isAuthenticated().then (isAuthenticated) ->
    $scope.isAuthenticated = isAuthenticated

  $scope.send = ->
    reportBuilder.buildCid()
    .then (message) ->
      mailer.send message, (response) ->
        if response.code? and response.code > 300
          errorFeedback = $mdToast.simple()
            .hideDelay(3000)
            .position('top right')
            .content("Failed to send message: '#{response.message}'")
          $mdToast.show errorFeedback
          $mdDialog.cancel()
        else
          dailyReport.sections.previousGoals = todaysGoals
          dailyReport.sections.todaysGoals = null
          dailyReport.save()
          sentFeedback = $mdToast.simple().position('top right').content('Email sent')
          $mdToast.show sentFeedback
          $mdDialog.cancel()
