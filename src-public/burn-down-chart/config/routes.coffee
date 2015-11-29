angular.module 'NotSoShitty.bdc'
.config ($stateProvider) ->
  $stateProvider
  .state 'burn-down-chart',
    url: '/burn-down-chart'
    controller: 'BurnDownChartCtrl'
    templateUrl: 'burn-down-chart/states/bdc/view.html'
