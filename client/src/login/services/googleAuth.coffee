angular.module 'Scrumble.login'
.service 'googleAuth', (
  $state
  $auth
  $http
  $q
  localStorageService
) ->
  userInfo = null

  getAuthorizationHeader = ->
    token = localStorageService.get 'google_token'
    if token?
      "Bearer " + token
    else
      null

  getUserInfo = ->
    deferred = $q.defer()
    if userInfo?
      deferred.resolve userInfo
    else
      $http.get(
        'https://content.googleapis.com/oauth2/v2/userinfo',
        headers:
          authorization: getAuthorizationHeader()
      ).then (response) ->
        userInfo = response.data
        deferred.resolve response.data
      .catch ->
        deferred.reject()
    deferred.promise

  logout: ->
    localStorageService.remove 'google_token'
    userInfo = null

  login: ->
    $auth.authenticate 'google'
    .then (response) ->
      localStorageService.set 'google_token', response.data.token

  getAuthorizationHeader: getAuthorizationHeader
  getUserInfo: getUserInfo
  isAuthenticated: ->
    deferred = $q.defer()
    if localStorageService.get 'google_token'
      getUserInfo()
      .then ->
        deferred.resolve true
      .catch ->
        deferred.resolve false
    else
      deferred.resolve false
    deferred.promise
