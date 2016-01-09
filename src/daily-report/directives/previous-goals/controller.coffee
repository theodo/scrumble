angular.module 'NotSoShitty.daily-report'
.controller 'PreviousGoalsCtrl', (
  $scope
  $q
  $mdMedia
  $mdDialog
  TrelloClient
  trelloCards
) ->
  trelloCards.getDoneCardIds $scope.sprint.doneColumn
  .then (cardIds) ->
    for card in $scope.goals
      card.display = true
      if card.id in cardIds
        card.isDone = true
      else
        card.isDone = false

  DialogController = ($scope, $mdDialog, goal) ->
    $scope.goal = goal
    $scope.hide = ->
      $mdDialog.hide()
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.save = ->
      $mdDialog.hide $scope.goal

  $scope.edit = (ev, goal) ->
    useFullScreen = ($mdMedia 'sm' or $mdMedia 'xs')
    $mdDialog.show(
      controller: DialogController
      templateUrl: 'daily-report/directives/previous-goals/edit-goal.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: useFullScreen
      resolve:
        goal: -> angular.copy goal
    ).then (editedGoal) ->
      goal.isDone = editedGoal.isDone
      goal.name = editedGoal.name
