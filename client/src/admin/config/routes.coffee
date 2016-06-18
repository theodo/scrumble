angular.module 'Scrumble.admin'
.config ($stateProvider) ->
  $stateProvider

  .state 'tab.admin',
    url: '/stats'
    controller: 'StatsCtrl'
    templateUrl: 'admin/states/daily-stats/view.html'
