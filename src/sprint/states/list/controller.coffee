angular.module 'Scrumble.sprint'
.controller 'SprintListCtrl', (
  $scope
  sprintUtils
  sprints
  project
) ->
  sprints.forEach (sprint) ->
    sprint.speed = sprintUtils.computeSpeed sprint
    sprint.dates.start = moment(sprint.dates.start).format "MMMM Do YYYY"
    sprint.dates.end = moment(sprint.dates.end).format "MMMM Do YYYY"

  $scope.sprints = sprints
  $scope.project = project
