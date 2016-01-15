angular.module 'Scrumble.daily-report'
.controller 'SelectGoalsCtrl', (
  $scope
  $q
  nssModal
  TrelloClient
  trelloCards
) ->
  trelloCards.getTodoCards $scope.project, $scope.sprint
  .then (cards) ->
    $scope.trelloCards = cards

  $scope.updateGoals = ->
    $scope.goals = _.filter $scope.trelloCards, 'selected'

  DialogController = ($scope, $controller, goal) ->
    angular.extend @, $controller('ModalCtrl', $scope: $scope)
    $scope.goal = goal

  $scope.edit = (ev, goal) ->
    nssModal.show
      controller: DialogController
      templateUrl: 'daily-report/directives/select-goals/edit-goal.html'
      targetEvent: ev
      resolve:
        goal: -> angular.copy goal
    .then (editedGoal) ->
      goal.name = editedGoal
