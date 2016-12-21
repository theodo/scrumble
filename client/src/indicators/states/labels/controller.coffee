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


  $scope.getColumnPointsByLabel = (columnId) ->
    $scope.chartOptions = null
    trelloUtils.getColumnPointsByLabel(columnId)
    .then (result) ->
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
          pointFormat: '{point.description}'
        plotOptions:
          column:
            stacking: 'normal'
            dataLabels:
              enabled: true
              format: '#{point.name}'
              color: 'white'
        series: result.data
