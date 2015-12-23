angular.module 'NotSoShitty.login'
.run (Permission, localStorageService) ->
  Permission.defineRole 'trello-authenticated', ->
    localStorageService.get('trello_token')?
