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

  $scope.sprints = _.sortBy sprints, (sprint) ->
    parseInt sprint.number
  .reverse()
  $scope.project = project
