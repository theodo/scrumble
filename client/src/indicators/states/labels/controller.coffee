angular.module 'Scrumble.indicators'
.controller 'LabelsCtrl', (
  $scope
  $stateParams
  Project
  trelloUtils
) ->
  Project.get projectId: $stateParams.projectId
  .then (project) ->
    trelloUtils.getListIdsAndNames(project.boardId)
    .then (boardLists) ->
      $scope.boardLists = boardLists

  $scope.toggleList = (list) ->
    if list.selected
      list.selected = false
    else
      list.selected = true

    getColumnPointsByLabel(_.filter($scope.boardLists, 'selected'))

  getColumnPointsByLabel = (columns) ->
    $scope.chartOptions = null
    trelloUtils.getColumnPointsByLabel(columns)
    .then (result) ->
      return unless result?
      $scope.chartOptions =
        chart:
          type: 'column'
        title:
          text: 'Points per labels'
        xAxis:
          categories: result.labels
        yAxis:
          min: 0
          title:
            text: 'Complexity points'
        legend:
          enabled: false
        tooltip:
          headerFormat: ''
          pointFormat: '<b>{point.list}</b><br /><br />{point.description}'
        plotOptions:
          column:
            groupPadding: 0
            stacking: 'normal'
            dataLabels:
              enabled: true
              format: '#{point.name}'
              color: 'white'
        series: result.data
