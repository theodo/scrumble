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

  $scope.deleteProblem = (problem, ev) ->
    $mdDialog.show($mdDialog.confirm()
      .title('Are you sure you want to do what you\'re trying to do?')
      .ariaLabel('delete confirm')
      .targetEvent(ev)
      .ok('Yes')
      .cancel('No')
    ).then ->
      problem.$delete().then fetchProblems

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
