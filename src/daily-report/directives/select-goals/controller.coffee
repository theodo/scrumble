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

  DialogController = ($scope, $mdDialog, goal) ->
    $scope.goal = goal
    $scope.hide = ->
      $mdDialog.hide()
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.save = ->
      $mdDialog.hide $scope.goal.name

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
