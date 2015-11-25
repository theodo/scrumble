'use strict'

app = angular.module 'NotSoShitty', [
  'ng'
  'ngResource'
  'ui.router'
  # 'ui.bootstrap'
  'app.templates'
  'Parse'
  'LocalStorageModule'
  'trello'

  'NotSoShitty.login'
  'NotSoShitty.settings'
  'NotSoShitty.storage'
]

app.config (
  $locationProvider
  $urlRouterProvider
  ParseProvider
) ->

  $locationProvider.hashPrefix '!'

  $urlRouterProvider.otherwise '/login'

  ParseProvider.initialize(
    "UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG", # Application ID
    "DGp8edP1LHPJ15GpDE3cp94bBaDq2hiMSqLEzfZB"  # REST API Key
  )
app.config (localStorageServiceProvider) ->
  localStorageServiceProvider.setPrefix ''

app.config (TrelloApiProvider) ->

  TrelloApiProvider.init
    key: '2dcb2ba290c521d2b5c2fd69cc06830e'
    secret: '38ddbedae05395a1a13323f60f5d95e0a40c7737938e449fe7ba669a0d72dae0'
    scopes:
      read: true
      write: true
      account: true
    AppName: 'Not So Shitty 2'

app.run ($rootScope, $state) ->
  $rootScope.$state = $state
