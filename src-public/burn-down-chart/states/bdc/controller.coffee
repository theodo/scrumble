angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', ($scope, BDCDataProvider) ->
  $scope.days = [
    label: 'Daily du Mercredi'
    standard: 10
    done: 12
  ,
    label: 'Daily du Jeudi'
    standard: 10
    done: 12
  ,
    label: 'Daily du Vendredi'
    standard: 10
    done: 12
  ]
  return
