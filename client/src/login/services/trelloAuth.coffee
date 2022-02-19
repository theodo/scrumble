angular.module 'Scrumble.login'
.service 'trelloAuth', ['localStorageService', 'TrelloClient', '$state', (
  localStorageService
  TrelloClient
  $state
) ->
  getTrelloInfo: ->
    TrelloClient.get('/member/me').then (response) -> response.data

  logout: ->
    localStorageService.remove 'trello_email'
    localStorageService.remove 'trello_token'
    $state.go 'trello-login'

  isLoggedUnsafe: ->
    token = localStorageService.get 'trello_token'
    token?

]