angular.module 'Scrumble.problems'
.controller 'AddProblemCtrl', (
  $scope,
  $mdDialog,
  problem,
  Problem,
  $stateParams
) ->
  $scope.problem = problem

  unless $scope.problem.happenedDate?
    $scope.problem.happenedDate = new Date

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.save = (problem) ->
    problem.type = 'red-tray'
    problem.projectId = $stateParams.projectId
    Problem.save(problem).then $mdDialog.hide
