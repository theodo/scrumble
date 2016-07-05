angular.module 'Scrumble.problems'
.controller 'AddProblemCtrl', (
  $scope,
  $mdDialog,
  problem,
  Problem,
  TagRepository
  $stateParams
) ->
  $scope.problem = problem
  $scope.problem.tagLabels ?= []

  $scope.formatTag = TagRepository.format

  unless $scope.problem.happenedDate?
    $scope.problem.happenedDate = new Date

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.save = (problem) ->
    problem.type = 'null'
    problem.projectId = $stateParams.projectId
    Problem.save(problem).then $mdDialog.hide
