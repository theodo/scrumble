angular.module 'NotSoShitty.daily-report'
.controller 'PreviewCtrl', ($scope, $mdDialog, $mdToast, mailer, message) ->
  $scope.message = message

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.send = ->
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
