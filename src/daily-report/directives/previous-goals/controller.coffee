angular.module 'NotSoShitty.daily-report'
.controller 'PreviousGoalsCtrl', (
  $scope
  $q
  nssModal
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

  DialogController = ($scope, $controller, goal) ->
    angular.extend @, $controller('ModalCtrl', $scope: $scope)
    $scope.goal = goal

  $scope.edit = (ev, goal) ->
    nssModal.show
      controller: DialogController
      templateUrl: 'daily-report/directives/previous-goals/edit-goal.html'
      targetEvent: ev
      resolve:
        goal: -> angular.copy goal
    .then (editedGoal) ->
      goal.isDone = editedGoal.isDone
      goal.name = editedGoal.name
