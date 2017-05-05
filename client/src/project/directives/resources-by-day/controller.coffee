angular.module 'Scrumble.settings'
.controller 'ResourcesByDayCtrl', ($scope) ->
  $scope.selected = []
  $scope.delete = ->
    for day in $scope.selected
      index = _.findIndex $scope.days, day
      _.remove $scope.days, day
      $scope.matrix.splice index, 1
    $scope.selected = []
    $scope.onUpdate()
