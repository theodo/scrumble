angular.module 'NotSoShitty.login'
.service 'trelloAuth', (
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
