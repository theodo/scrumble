angular.module 'Scrumble.daily-report'
.controller 'SelectGoalsCtrl', ['$scope', '$mdToast', 'trelloCards', 'markdownGenerator', (
  $scope
  $mdToast
  trelloCards
  markdownGenerator
) ->
  $scope.goals = []
  $scope.errors = {}
  unless $scope.project?.columnMapping?.blocked?
    $scope.errors.blockedColumnMissing = true
  unless $scope.project?.columnMapping?.doing? && $scope.project.columnMapping.doing.length > 0
    $scope.errors.doingColumnMissing = true
  unless $scope.project?.columnMapping?.toValidate?
    $scope.errors.toValidateColumnMissing = true
  unless $scope.project?.columnMapping?.sprint?
    $scope.errors.sprintColumnMissing = true

  loadCards = ->
    trelloCards.getTodoCards $scope.project, $scope.sprint
    .then (cards) ->
      $scope.trelloCards = cards
  loadCards()

  generateMarkdown = (goals) ->
    $scope.markdown = markdownGenerator.goals(goals)

  $scope.update = (goals) ->
    loadCards()
    generateMarkdown(goals)
]