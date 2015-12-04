angular.module 'NotSoShitty.login'
.service 'User', (
  $auth
  TrelloClient
) ->
  getTrelloInfo: ->
    TrelloClient.get('/member/me').then (response) -> response.data
