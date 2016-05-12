angular.module 'Scrumble.indicators'
.controller 'CelerityCtrl', (
  $scope
  Project
  Sprint
  sprintUtils
) ->
  Sprint.getByProjectId $scope.project.objectId
  .then (sprints) ->
    sprintNumbers = ['sprint']
    expected = [ 'Expected Celerity' ]
    actual = [ 'Actual Celerity' ]
    sprints = _.sortBy sprints, (sprint) -> Number sprint.number
    for sprint in sprints
      sprintNumbers.push Number sprint.number
      expected.push Number sprintUtils.computeExpectedSpeed sprint
      actual.push Number sprintUtils.computeSpeed sprint
    console.log [sprintNumbers, expected, actual]
    chart = c3.generate
      bindto: '#celerity-cart'
      data:
        x: 'sprint'
        columns: [sprintNumbers, expected, actual]
