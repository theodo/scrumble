angular.module 'Scrumble.problems'
.controller 'AddProblemCtrl', (
  $scope,
  $mdDialog,
  problem,
  Problem,
  Project,
  TagRepository
  $stateParams
) ->
  $scope.problem = problem
  $scope.problem.tagLabels ?= []

  Project.get(projectId: $stateParams.projectId)
  .then (project) ->
    $scope.project = project

  $scope.formatTag = TagRepository.format

  unless $scope.problem.happenedDate?
    $scope.problem.happenedDate = new Date

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.save = (problem) ->
    problem.type = 'null'
    problem.projectId = $stateParams.projectId
    Problem.save(problem).then $mdDialog.hide
