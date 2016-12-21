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
    trelloUtils.getColumnPointsByLabel(columnId)
    .then (sumsByLabel) ->
      console.log sumsByLabel
      console.log _.keys sumsByLabel
      console.log _.values sumsByLabel
      $scope.chartOptions =
        chart:
          type: 'column'
        title:
          text: 'Points per labels'
        xAxis:
          categories: _.keys sumsByLabel
        series: [{
          data: _.values sumsByLabel
        }]
