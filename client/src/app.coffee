'use strict'

app = angular.module 'Scrumble', [
  'ng'
  'ngResource'
  'ngAnimate'
  'ngSanitize'
  'ngMaterial'
  'ngMessages'
  'md.data.table' # soon included in ngMaterial
  'ui.router'
  # 'ui.bootstrap'
  'app.templates'
  'Parse'
  'LocalStorageModule'
  'satellizer'
  'permission'
  'trello-api-client'
  'angular-async-loader'

  'Scrumble.constants'
  'Scrumble.models'
  'Scrumble.sprint'
  'Scrumble.common'
  'Scrumble.daily-report'
  'Scrumble.gmail-client'
  'Scrumble.feedback'
  'Scrumble.login'
  'Scrumble.settings'
  'Scrumble.storage'
  'Scrumble.board'
  'Scrumble.indicators'
  'Scrumble.wait'
]

app.config (
  $locationProvider
  $urlRouterProvider
  ParseProvider
) ->

  $locationProvider.hashPrefix '!'

  $urlRouterProvider.otherwise '/'

  ParseProvider.initialize(
    "UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG", # Application ID
    "DGp8edP1LHPJ15GpDE3cp94bBaDq2hiMSqLEzfZB"  # REST API Key
  )
app.config (localStorageServiceProvider) ->
  localStorageServiceProvider.setPrefix ''

app.config (TrelloClientProvider) ->
  TrelloClientProvider.init {
    key: '2dcb2ba290c521d2b5c2fd69cc06830e'
    appName: 'Scrumble'
    tokenExpiration: 'never'
    scope: ['read', 'account'] #, 'write']
    returnUrl: window.location.origin
  }

app.config ($mdIconProvider) ->
  $mdIconProvider
    .defaultIconSet 'icons/mdi.light.svg'

app.run ($rootScope, $state) ->
  $rootScope.$state = $state
