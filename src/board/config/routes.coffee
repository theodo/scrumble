angular.module 'Scrumble.board'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.board',
    url: '/'
    controller: 'BoardCtrl'
    templateUrl: 'board/states/board/view.html'
