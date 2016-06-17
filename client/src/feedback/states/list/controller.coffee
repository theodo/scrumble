angular.module 'Scrumble.feedback'
.controller 'FeedbackListCtrl', ($scope, $mdDialog, Feedback) ->
  Feedback.find().then (feedbacks) ->
    $scope.feedbacks = feedbacks

  $scope.openDialog = (feedback, ev) ->
    $mdDialog.show
      controller: ($scope, $mdDialog, feedback) ->
        $scope.feedback = feedback
        $scope.hide = ->
          $mdDialog.hide()
        $scope.cancel = ->
          $mdDialog.cancel()
        $scope.save = ->
          $mdDialog.hide $scope.feedback
      templateUrl: 'feedback/states/list/dialog.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
      resolve:
        feedback: -> angular.copy feedback
    .then (feedback) ->
      feedback.$update()
    .then ->
      Feedback.find()
    .then (feedbacks) ->
      $scope.feedbacks = feedbacks
