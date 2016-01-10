angular.module 'NotSoShitty.daily-report'
.controller 'SelectGoalsCtrl', (
  $scope
  $q
  $mdMedia
  $mdDialog
  TrelloClient
  trelloCards
) ->
  trelloCards.getTodoCards $scope.project
  .then (cards) ->
    $scope.trelloCards = cards

  $scope.updateGoals = ->
    $scope.goals = _.filter $scope.trelloCards, 'selected'

  DialogController = ($scope, $controller, goal) ->
    angular.extend @, $controller('ModalCtrl', $scope: $scope)
    $scope.goal = goal

  $scope.edit = (ev, goal) ->
    useFullScreen = ($mdMedia 'sm' or $mdMedia 'xs')
    $mdDialog.show(
      controller: DialogController
      templateUrl: 'daily-report/directives/select-goals/edit-goal.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: useFullScreen
      resolve:
        goal: -> angular.copy goal
    ).then (editedGoal) ->
      goal.name = editedGoal
