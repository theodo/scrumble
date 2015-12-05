angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', ($scope, BDCDataProvider) ->
  $scope.tableData = [
    date: new Date(2015,12,1)
    standard: 0
    done: 0
  ,
    date: new Date(2015,12,2)
    standard: 8
    done: 12
  ,
    date: new Date(2015,12,3)
    standard: 16
    done: 13
  ,
    date: new Date(2015,12,6)
    standard: 22
    done: 24
  ,
    date: new Date(2015,12,7)
    standard: 30
    done: 28
  ,
    date: new Date(2015,12,8)
    standard: 40
    done: 38
  ]
  return
