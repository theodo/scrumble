angular.module 'Scrumble.indicators'
.controller 'CelerityCtrl', ['$scope', 'Project', 'Sprint', 'sprintUtils', (
  $scope
  Project
  Sprint
  sprintUtils
) ->
  Sprint.query
    filter:
      where:
        projectId: $scope.project.id
  .then (sprints) ->
    sprintNumbers = ['sprint']
    expected = [ 'Expected Celerity' ]
    actual = [ 'Actual Celerity' ]
    sprints = _.sortBy sprints, (sprint) -> Number sprint.number
    for sprint in sprints
      sprintNumbers.push Number sprint.number
      expected.push Number sprintUtils.computeExpectedSpeed sprint
      actual.push Number sprintUtils.computeSpeed sprint

    chart = c3.generate
      bindto: '#celerity-cart'
      data:
        x: 'sprint'
        columns: [sprintNumbers, expected, actual]
      axis:
        y:
          min: 0
]