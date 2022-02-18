template = require './dialog.html'

angular.module 'Scrumble.feedback'
.controller 'feedbackCallToActionCtrl', ['$scope', '$mdDialog', '$mdMedia', ($scope, $mdDialog, $mdMedia) ->
  $scope.customFullscreen = $mdMedia 'sm'
  $scope.openFeedbackModal = (ev) ->
    $mdDialog.show(
      controller: DialogController
      template: template
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

  DialogController = ['$scope', '$mdDialog', '$controller', 'Feedback', 'localStorageService', ($scope, $mdDialog, $controller, Feedback, localStorageService) ->
    angular.extend @, $controller('ModalCtrl', $scope: $scope)
    $scope.message = null

    $scope.doing = false

    $scope.send = ->
      if $scope.message?
        $scope.doing = true
        feedback = Feedback.new()
        feedback.message = $scope.message
        feedback.$save().then ->
          $mdDialog.hide()
  ]
]