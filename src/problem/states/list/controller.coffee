angular.module 'NotSoShitty.login'
.controller 'ProblemListCtrl', (
  $scope
  $stateParams
  problems
) ->
  $scope.projectId = $stateParams.projectId
  $scope.problems = problems
