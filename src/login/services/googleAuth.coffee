angular.module 'NotSoShitty.login'
.service 'googleAuth', (
  $state
  $auth
  $http
  $q
  localStorageService
) ->
  userInfo = null

  getAuthorizationHeader = ->
    "Bearer " + localStorageService.get 'google_token'

  getUserInfo = ->
    deferred = $q.defer()
    if userInfo?
      deferred.resolve userInfo
    else
      $http.get(
        'https://content.googleapis.com/oauth2/v2/userinfo',
        headers:
          authorization: "Bearer " + localStorageService.get 'google_token'
      ).then (response) ->
        deferred.resolve response.data
      .catch ->
        deferred.reject()
    deferred.promise

  logout: ->
    localStorageService.remove 'google_token'

  login: ->
    $auth.authenticate 'google'
    .then (response) ->
      localStorageService.set 'google_token', response.access_token

  getAuthorizationHeader: getAuthorizationHeader
  getUserInfo: getUserInfo
  isAuthenticated: ->
    deferred = $q.defer()
    if localStorageService.get 'google_token'
      getUserInfo().then (user) ->
        deferred.resolve true
      .catch ->
        deferred.resolve false
    else
      deferred.resolve false
    deferred.promise
