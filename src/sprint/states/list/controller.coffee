angular.module 'Scrumble.sprint'
.controller 'SprintListCtrl', (
  $scope
  sprintUtils
  sprints
  project
) ->
  _.forEach sprints, (sprint) ->
    sprint.speed = sprintUtils.computeSpeed sprint

  $scope.sprints = sprints
  $scope.project = project
