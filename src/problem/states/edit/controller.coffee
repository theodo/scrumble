angular.module 'NotSoShitty.login'
.controller 'ProblemEditCtrl', (
  $scope
  $state
  problem
  project
) ->
  $scope.problem = problem
  $scope.problem.project = project
  $scope.teamMembers = _.union project.team.dev, project.team.rest

  $scope.save = ->
    problem.save().then ->
      $state.go 'tab.problem.list', projectId: project.objectId
