angular.module 'Scrumble.feedback'
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

  DialogController = ($scope, $mdDialog, $controller, Feedback, localStorageService) ->
    angular.extend @, $controller('ModalCtrl', $scope: $scope)
    $scope.message = null

    $scope.doing = false

    $scope.send = ->
      if $scope.message?
        $scope.doing = true
        feedback = new Feedback()
        feedback.reporter = localStorageService.get 'trello_email'
        feedback.message = $scope.message
        feedback.save().then ->
          $mdDialog.hide()
