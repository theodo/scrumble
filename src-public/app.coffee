'use strict'

app = angular.module 'NotSoShitty', [
  'ng'
  'ngResource'
  'ngAnimate'
  'ngMaterial'
  'ui.router'
  # 'ui.bootstrap'
  'app.templates'
  'Parse'
  'LocalStorageModule'
  'satellizer'
  'permission'
  'trello-api-client'


  'NotSoShitty.login'
  'NotSoShitty.settings'
  'NotSoShitty.storage'
  'NotSoShitty.bdc'
  'NotSoShitty.common'
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

app.config (TrelloClientProvider) ->
  TrelloClientProvider.init {
    key: '2dcb2ba290c521d2b5c2fd69cc06830e'
    appName: 'Not So Shitty'
    tokenExpiration: 'never'
    scope: ['read', 'write', 'account']
  }

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme('default').primaryPalette('blue').accentPalette 'grey'
  return

app.run ($rootScope, $state) ->
  $rootScope.$state = $state
