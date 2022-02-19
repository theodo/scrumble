template = require '../states/trello/view.html'

angular.module 'Scrumble.login'
.config ['$stateProvider', ($stateProvider) ->
  $stateProvider
  .state 'trello-login',
    url: '/login/trello'
    controller: 'TrelloLoginCtrl'
    template: template
]