angular.module 'NotSoShitty.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/view.html'
