angular.module 'NotSoShitty.login'
.config ($stateProvider) ->
  $stateProvider
  .state 'trello-login',
    url: '/login/trello'
    controller: 'TrelloLoginCtrl'
    templateUrl: 'login/states/trello/view.html'
