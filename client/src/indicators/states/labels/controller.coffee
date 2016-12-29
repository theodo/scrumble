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
      $scope.allBoardLists = boardLists

  $scope.selectedBoardLists = []

  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (list) ->
      list.name.toLowerCase().indexOf(lowercaseQuery) != -1

  $scope.querySearch = (query) ->
    $scope.allBoardLists.filter(createFilterFor(query))

  $scope.filterSelected = true

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

  $scope.$watch 'selectedBoardLists.length', (lists) ->
    getColumnPointsByLabel($scope.selectedBoardLists)
