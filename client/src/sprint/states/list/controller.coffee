angular.module 'Scrumble.sprint'
.controller 'SprintListCtrl', (
  $scope
  sprintUtils
  project
) ->
  _.forEach project.sprints, (sprint) ->
    sprint.speed = sprintUtils.computeSpeed sprint
    sprint.success = sprintUtils.computeSuccess sprint

  $scope.sprints = project.sprints
  $scope.project = project
