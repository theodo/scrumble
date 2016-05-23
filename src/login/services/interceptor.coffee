angular.module 'Scrumble.login'
.config ($httpProvider) ->
  $httpProvider.interceptors.push (ApiAccessToken, API_URL, $q, $rootScope) ->
    request: (config) ->
      return config unless _.startsWith config.url, API_URL
      token = ApiAccessToken.get()
      if token?
        config.headers.Authorization = token
      config
