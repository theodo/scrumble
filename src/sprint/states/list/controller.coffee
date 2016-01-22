angular.module 'Scrumble.sprint'
.controller 'SprintListCtrl', (
  $scope
  sprintUtils
  sprints
  project
) ->
  _.forEach sprints, (sprint) ->
    sprint.speed = sprintUtils.computeSpeed sprint
    sprint.success = sprintUtils.computeSuccess sprint

  $scope.sprints = sprints
  $scope.project = project
