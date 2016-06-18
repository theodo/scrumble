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
  'LocalStorageModule'
  'satellizer'
  'permission'
  'trello-api-client'
  'angular-async-loader'
  'angularDateInterceptor'
  'angularDateInterceptor'
  'trello'

  'Scrumble.constants'
  'Scrumble.models'
  'Scrumble.sprint'
  'Scrumble.organization'
  'Scrumble.common'
  'Scrumble.daily-report'
  'Scrumble.gmail-client'
  'Scrumble.feedback'
  'Scrumble.login'
  'Scrumble.settings'
  'Scrumble.storage'
  'Scrumble.indicators'
  'Scrumble.wait'
]

app.config (
  $locationProvider
  $urlRouterProvider
) ->

  $locationProvider.hashPrefix '!'

  $urlRouterProvider.otherwise '/'

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
