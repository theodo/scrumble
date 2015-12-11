angular.module 'NotSoShitty.login'
.config ($stateProvider) ->
  $stateProvider
  .state 'trello-login',
    url: '/login/trello'
    controller: 'TrelloLoginCtrl'
    templateUrl: 'login/states/trello/view.html'

  .state 'tab.google-login',
    url: '/login/google'
    controller: 'GoogleLoginCtrl'
    templateUrl: 'login/states/google/view.html'
