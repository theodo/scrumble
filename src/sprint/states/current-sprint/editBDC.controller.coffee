angular.module 'NotSoShitty.bdc'
.controller 'EditBDCCtrl', ($scope, $mdDialog, data, trelloUtils, doneColumn) ->
  $scope.data = data

  getCurrentDayIndex = (data) ->
    for day, i in data
      return i unless day.done?
  $scope.currentDayIndex = getCurrentDayIndex $scope.data

  $scope.hide = ->
    $mdDialog.hide()
  $scope.cancel = ->
    $mdDialog.cancel()
  $scope.save = ->
    $mdDialog.hide $scope.data
  $scope.fetchTrelloDonePoints = ->
    if doneColumn?
      trelloUtils.getColumnPoints doneColumn
      .then (points) ->
        $scope.data[$scope.currentDayIndex].done = points
