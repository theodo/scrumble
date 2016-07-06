angular.module 'Scrumble.problems'
.controller 'ProblemListCtrl', (
  $scope,
  $mdDialog,
  $mdMedia,
  $stateParams
) ->

  $scope.projectId = $stateParams.projectId

  $scope.$on 'problem:clicked', (e, problem, ev) ->
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
    .then ->
      $scope.$broadcast('problem:saved')
