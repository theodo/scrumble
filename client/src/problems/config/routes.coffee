angular.module 'Scrumble.problems'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.problems',
    url: '/project/:projectId/problems'
    controller: 'ProblemListCtrl'
    template: require('../states/problem-list/view.html')
