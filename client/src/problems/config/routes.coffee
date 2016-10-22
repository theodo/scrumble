angular.module 'Scrumble.problems'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.problems',
    url: '/project/:projectId/problems'
    controller: 'ProblemListCtrl'
    templateUrl: 'problems/states/problem-list/view.html'

  .state 'tab.board-group-problems',
    url: '/board-group/:boardGroupId/problems'
    controller: 'BoardGroupProblemCtrl'
    templateUrl: 'problems/states/board-group-problem/view.html'

  .state 'tab.board-groups',
    url: '/board-groups'
    controller: 'BoardGroupCtrl'
    templateUrl: 'problems/states/board-groups/view.html'
