angular.module 'Scrumble.login'
.service 'ApiAccessToken', ['localStorageService', (localStorageService) ->
  get: ->
    localStorageService.get 'api_token'
  set: (token) ->
    localStorageService.set 'api_token', token
  remove: ->
    localStorageService.remove 'api_token'
]