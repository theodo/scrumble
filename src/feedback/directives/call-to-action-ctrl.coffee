angular.module 'NotSoShitty.feedback'
.controller 'feedbackCallToActionCtrl', ($scope, $mdDialog, $mdMedia) ->
  $scope.customFullscreen = $mdMedia 'sm'
  $scope.openFeedbackModal = (ev) ->
    $mdDialog.show(
      controller: DialogController
      templateUrl: 'feedback/directives/dialog.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: $mdMedia('sm') and $scope.customFullscreen).then ((answer) ->
      $scope.status = 'You said the information was "' + answer + '".'
      return
    ), ->
      $scope.status = 'You cancelled the dialog.'
      return
    $scope.$watch (->
      $mdMedia 'sm'
    ), (sm) ->
      $scope.customFullscreen = sm == true
      return
    return

  DialogController = ($scope, $mdDialog, Feedback, localStorageService) ->
    $scope.message = null

    $scope.hide = ->
      $mdDialog.hide()

    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.send = ->
      console.log 'yolo'
      if $scope.message?
        feedback = new Feedback()
        feedback.reporter = localStorageService.get 'trello_email'
        feedback.message = $scope.message
        feedback.save().then ->
          $mdDialog.hide()
