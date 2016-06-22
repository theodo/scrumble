angular.module 'Scrumble.problems'
.controller 'ProblemListCtrl', (
  $scope,
  $mdDialog,
  $mdMedia,
  $stateParams,
  Problem
) ->
  fetchProblems = ->
    $scope.loading = true
    Problem.query(
      filter:
        where:
          projectId: $stateParams.projectId
        order: 'happenedDate DESC'
    ).then (problems) ->
      $scope.problems = problems
      $scope.loading = false

  $scope.editProblem = (problem, ev) ->
    open(problem, ev)

  $scope.addProblem = (ev) ->
    open(null, ev)

  open = (problem, ev) ->
    $mdDialog.show
      controller: 'AddProblemCtrl'
      templateUrl: 'problems/states/problem-edit/view.html'
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: $mdMedia 'sm'
      resolve:
        problem: (Problem) -> angular.copy(problem) or Problem.new()
    .then fetchProblems

  fetchProblems()
