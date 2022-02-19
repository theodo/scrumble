angular.module 'Scrumble.login'
.config ['TrelloApiProvider', (TrelloApiProvider) ->
  TrelloApiProvider.init
    key: TRELLO_KEY
    scope: {read: true, write: false, account: true}
    name: 'Scrumble'
]