angular.module 'NotSoShitty.settings'
.controller 'ResourcesByDayCtrl', ($scope) ->
  changeResource = (dayIndex, memberIndex, matrix) ->
    matrix[dayIndex][memberIndex] += 0.5
    if matrix[dayIndex][memberIndex] > 1
      matrix[dayIndex][memberIndex] = 0
    matrix

  $scope.resourceClick = (i, j) ->
    $scope.matrix = angular.copy changeResource i, j, $scope.matrix
    $scope.onUpdate()
    return

  $scope.selected = []
  $scope.delete = ->
    for day in $scope.selected
      index = _.findIndex $scope.days, day
      _.remove $scope.days, day
      $scope.matrix.splice index, 1
    $scope.selected = []
    $scope.onUpdate()
