angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', ($scope, BDCDataProvider) ->
  $scope.tableData = [
    label: 'Daily du Mercredi'
    standard: 0
    done: 0
  ,
    label: 'Daily du Jeudi'
    standard: 8
    done: 12
  ,
    label: 'Daily du Vendredi'
    standard: 16
    done: 20
  ]
  return
