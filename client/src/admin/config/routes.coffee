template = require '../states/daily-stats/view.html'

angular.module 'Scrumble.admin'
.config ($stateProvider) ->
  $stateProvider

  .state 'tab.admin',
    url: '/stats'
    controller: 'StatsCtrl'
    template: template
