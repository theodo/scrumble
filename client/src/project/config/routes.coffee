angular.module 'Scrumble.settings'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.project',
    url: '/project'
    controller: 'ProjectCtrl'
    templateUrl: 'project/states/main/view.html'
  .state 'tab.team',
    url: '/project/:projectId/team'
    controller: 'TeamCtrl'
    templateUrl: 'project/states/team/view.html'
