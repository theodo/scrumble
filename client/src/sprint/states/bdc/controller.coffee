angular.module 'Scrumble.sprint'
.controller 'BoardCtrl', ['$scope', '$timeout', 'bdc', 'trelloUtils', 'sprintUtils', 'Sprint', ($scope, $timeout, bdc, trelloUtils, sprintUtils, Sprint) ->
  $scope.tableData = angular.copy $scope.sprint.bdcData
  $scope.selectedIndex = 0
  getCurrentDayIndex = (data) ->
    return 0 unless data?
    for day, i in data
      return i unless day.done?
  $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.$on 'bdc:update', ->
    $scope.tableData = angular.copy $scope.sprint.bdcData
    $scope.currentDayIndex = getCurrentDayIndex $scope.tableData
    $scope.tableData = angular.copy $scope.sprint.bdcData

  $scope.fetchTrelloDonePoints = ->
    if $scope.sprint.doneColumn?
      trelloUtils.getColumnPoints $scope.sprint.doneColumn
      .then (points) ->
        $scope.tableData[$scope.currentDayIndex].done = points

  $scope.save = ->
    $scope.sprint.bdcData = $scope.tableData
    $scope.selectedIndex = 0
    Sprint.save $scope.sprint
]
