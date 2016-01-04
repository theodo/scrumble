angular.module 'NotSoShitty.daily-report'
.controller 'PreviewCtrl', (
  $scope
  $sce
  $mdDialog
  $mdToast
  googleAuth
  mailer
  message
  rawMessage
  reportBuilder
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
    reportBuilder.render(rawMessage, true).then (message) ->
      mailer.send message, (response) ->
        if response.code? and response.code > 300
          errorFeedback = $mdToast.simple()
            .hideDelay(3000)
            .position('top right')
            .content("Failed to send message: '#{response.message}'")
          $mdToast.show errorFeedback
          $mdDialog.cancel()
        else
          sentFeedback = $mdToast.simple()
            .hideDelay(1000)
            .position('top right')
            .content('Email sent')
          $mdToast.show sentFeedback
          $mdDialog.cancel()
