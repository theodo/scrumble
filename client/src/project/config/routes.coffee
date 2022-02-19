templateMain = require '../states/main/view.html'
templateTeam = require '../states/team/view.html'

angular.module 'Scrumble.settings'
.config ['$stateProvider', ($stateProvider) ->
  $stateProvider
  .state 'tab.project',
    url: '/project'
    controller: 'ProjectCtrl'
    template: templateMain
  .state 'tab.team',
    url: '/project/:projectId/team'
    controller: 'TeamCtrl'
    template: templateTeam
]