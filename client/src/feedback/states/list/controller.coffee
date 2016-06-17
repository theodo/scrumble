angular.module 'Scrumble.feedback'
.controller 'FeedbackListCtrl', ($scope, $mdDialog, Feedback) ->
  fetchFeedbacks = ->
    Feedback.find
      filter:
        where:
          status:
            neq: 'done'
        order: 'createdAt DESC'
    .then (feedbacks) ->
      $scope.feedbacks = feedbacks

  fetchFeedbacks()

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
    .then fetchFeedbacks
