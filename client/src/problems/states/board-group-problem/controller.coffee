angular.module 'Scrumble.problems'
.controller 'BoardGroupProblemCtrl', (
  $scope
  $stateParams
  $state
  BoardGroup
  trelloUtils
  project
) ->
  $scope.loading = true

  BoardGroup.getProblems($stateParams.boardGroupId)
  .then (problems) ->
    $scope.problems = _.map problems, (problem) ->
      if trelloUtils.isTrelloCardUrl problem.link
        trelloUtils.getCardInfoFromUrl problem.link
        .then (info) ->
          problem.card = info
      problem
    $scope.loading = false

  $scope.$on 'boardGroup:selected', (ev, boardGroupId) ->
    if boardGroupId?
      $state.go('tab.board-group-problems', boardGroupId: boardGroupId)
    else
      $state.go('tab.problems', projectId: project.id)
