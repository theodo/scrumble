angular.module 'Scrumble.problems'
.controller 'ProblemListCtrl', (
  $scope,
  $mdDialog,
  $mdMedia,
  $stateParams
  $state
) ->

  $scope.projectId = $stateParams.projectId
  $scope.selectedIndex = 0

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

  $scope.printProblems = ->
    window.print()

  $scope.$on 'boardGroup:selected', (ev, boardGroupId) ->
    if boardGroupId?
      $state.go('tab.board-group-problems', boardGroupId: boardGroupId)
    else
      $state.go('tab.problems', projectId: project.id)
