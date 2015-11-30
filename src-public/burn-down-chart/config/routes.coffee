angular.module 'NotSoShitty.bdc'
.config ($stateProvider) ->
  $stateProvider
  .state 'burn-down-chart-main',
    url: '/burn-down-chart'
    templateUrl: 'burn-down-chart/states/main/view.html'
  .state 'burn-down-chart',
    url: '/burn-down-chart'
    controller: 'BurnDownChartCtrl'
    templateUrl: 'burn-down-chart/states/bdc/view.html'
  .state 'burn-down-table',
    url: '/burn-down-table'
    controller: 'BDCTableCtrl'
    templateUrl: 'burn-down-chart/states/table/view.html'
