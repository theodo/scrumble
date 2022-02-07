'use strict'

app = angular.module 'Scrumble', [
  'ng'
  'ngRoute'
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
  'trello'

  'Scrumble.constants'
  'Scrumble.models'
  'Scrumble.sprint'
  'Scrumble.organization'
  'Scrumble.common'
  'Scrumble.daily-report'
  'Scrumble.policy'
  'Scrumble.gmail-client'
  'Scrumble.feedback'
  'Scrumble.login'
  'Scrumble.settings'
  'Scrumble.indicators'
  'Scrumble.wait'
  'Scrumble.admin'
  'Scrumble.problems'
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
    key: '502ec3543cb5e557eb49a41cf286f97a'
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
