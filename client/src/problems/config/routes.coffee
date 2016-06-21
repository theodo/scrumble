angular.module 'Scrumble.problems'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.red-tray',
    url: '/project/:projectId/red-tray'
    controller: 'RedTrayListCtrl'
    templateUrl: 'problems/states/red-tray-list/view.html'
