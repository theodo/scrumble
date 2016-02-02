angular.module 'Scrumble.indicators'
.controller 'ProjectIndicatorsCtrl', (
  $scope
  sprints
  project
) ->
  $scope.sprints = sprints

  buildData = (sprints) ->
    sprints = sprints.reverse()
    data = [
      key: sprints[0]?.indicators?.clientSatisfaction?.questions[0]?.label
      values: []
    ,
      key: sprints[0]?.indicators?.clientSatisfaction?.questions[1]?.label
      values: []
    ]
    for sprint in sprints
      data[0].values.push
        x: parseInt sprint.number
        y: sprint?.indicators?.clientSatisfaction?.questions[0]?.answer
      data[1].values.push
        x: parseInt sprint.number
        y: sprint?.indicators?.clientSatisfaction?.questions[1]?.answer
    data


  console.log sprints
  $scope.project = project
  nv.addGraph ->
    chart = nv.models.multiBarChart().reduceXTicks(false).tooltips(true)
    chart.xAxis.tickFormat d3.format(',f')
    chart.yAxis.tickFormat d3.format(',.1f')
    d3.select('#chart svg').datum(buildData(sprints)).transition().duration(500).call chart
    nv.utils.windowResize chart.update
    chart
