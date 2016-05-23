angular.module 'Scrumble.daily-report'
.controller 'SelectGoalsCtrl', (
  $scope
  trelloCards
) ->
  $scope.goals = []
  $scope.errors = {}
  unless $scope.project?.columnMapping?.blocked?
    $scope.errors.blockedColumnMissing = true
  unless $scope.project?.columnMapping?.doing?
    $scope.errors.doingColumnMissing = true
  unless $scope.project?.columnMapping?.toValidate?
    $scope.errors.toValidateColumnMissing = true
  unless $scope.project?.columnMapping?.sprint?
    $scope.errors.sprintColumnMissing = true

  todoCardPromise = trelloCards.getTodoCards $scope.project, $scope.sprint
  .then (cards) ->
    $scope.trelloCards = cards

  $scope.loadCards = ->
    todoCardPromise

  $scope.generateMarkdown = (goals) ->
    unless _.isArray goals
      $scope.markdown = ""
      return
    goalsNames = ("- <span card-id='#{goal.id}'>" + goal.name + "</span>" for goal in goals)
    $scope.markdown = goalsNames.join "\n"
