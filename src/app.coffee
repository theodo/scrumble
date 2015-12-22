'use strict'

app = angular.module 'NotSoShitty', [
  'ng'
  'ngResource'
  'ngAnimate'
  'ngSanitize'
  'ngMaterial'
  'md.data.table' # soon included in ngMaterial
  'ui.router'
  # 'ui.bootstrap'
  'app.templates'
  'Parse'
  'LocalStorageModule'
  'satellizer'
  'permission'
  'trello-api-client'
  'angular-google-gapi'

  'NotSoShitty.bdc'
  'NotSoShitty.common'
  'NotSoShitty.daily-report'
  'NotSoShitty.gmail-client'
  'NotSoShitty.feedback'
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

  $urlRouterProvider.otherwise '/login/trello'

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
    scope: ['read', 'account'] #, 'write']
  }

app.config ($mdIconProvider) ->
  $mdIconProvider
    .defaultIconSet 'icons/mdi.light.svg'

app.run ($rootScope, $state) ->
  $rootScope.$state = $state

app.config ($stateProvider) ->
  $stateProvider
  .state 'tab',
    abstract: true
    templateUrl: 'common/states/base.html'
