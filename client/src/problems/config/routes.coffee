angular.module 'Scrumble.problems'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.problems',
    url: '/project/:projectId/problems'
    controller: 'ProblemListCtrl'
    templateUrl: 'problems/states/problem-list/view.html'
