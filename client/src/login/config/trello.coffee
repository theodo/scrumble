angular.module 'Scrumble.login'
.config (TrelloApiProvider, API_URL, TRELLO_KEY) ->
  TrelloApiProvider.init
    key: TRELLO_KEY
    scope: {read: true, write: false, account: true}
    name: 'Scrumble'
