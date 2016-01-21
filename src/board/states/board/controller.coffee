angular.module 'Scrumble.sprint'
.controller 'BoardCtrl', ($scope, $timeout, bdc, trelloUtils, sprintUtils) ->
  unless $scope.sprint?.bdcData
    $scope.sprint.bdcData = sprintUtils.generateBDC $scope.sprint.dates.days, $scope.sprint.resources, $scope.sprint.bdcData
  $scope.tableData = angular.copy $scope.sprint.bdcData
  $scope.selectedIndex = 0
  getCurrentDayIndex = (data) ->
    return 0 unless data?
    for day, i in data
      return i unless day.done?
  $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.fetchTrelloDonePoints = ->
    if $scope.sprint.doneColumn?
      trelloUtils.getColumnPoints $scope.sprint.doneColumn
      .then (points) ->
        $scope.tableData[$scope.currentDayIndex].done = points

  $scope.save = ->
    $scope.sprint.bdcData = $scope.tableData
    $scope.selectedIndex = 0
    $timeout -> # bdc needs to be rendered before getting the png
      svg = d3.select('#bdcgraph')[0][0].firstChild
      bdc.saveImage $scope.sprint, svg
