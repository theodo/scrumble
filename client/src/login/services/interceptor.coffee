angular.module 'Scrumble.login'
.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push ['ApiAccessToken', '$q', '$rootScope', (ApiAccessToken, $q, $rootScope) ->
    request: (config) ->
      return config unless config.url.startsWith API_URL
      token = ApiAccessToken.get()
      if token?
        config.headers.Authorization = token
      config
  ]
]