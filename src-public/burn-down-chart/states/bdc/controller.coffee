angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', ($scope, BDCDataProvider) ->
  $scope.bdcData = [
    date: new Date 2015, 11, 30
    standard: 0
    done: 0
  ,
    date: new Date 2015, 11, 31
    standard: 8
    done: 12
  ,
    date: new Date 2015, 12, 1
    standard: 16
    done: 13
  ,
    date: new Date 2015, 12, 2
    standard: 22
    done: 24
  ,
    date: new Date 2015, 12, 3
    standard: 30
    done: 28
  ,
    date: new Date 2015, 12, 4
    standard: 40
    done: null
  ]
  return
