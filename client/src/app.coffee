'use strict'
jquery = require 'jquery';
window.jQuery = jquery;
window.$ = jquery;

angular = require 'angular'
ngResource = require 'angular-resource'
ngRoute = require 'angular-route'
ngAnimate = require 'angular-animate'
ngSanitize = require 'angular-sanitize'
ngMaterial = require 'angular-material'
ngMessages = require 'angular-messages'
mdDaraTable = require 'angular-material-data-table'
ngUiRouter = require 'angular-ui-router'
localStorageModule = require 'angular-local-storage'
satellizer = require 'satellizer'
permission = require 'angular-permission'
trelloApiClient = require 'angular-trello-api-client/dist/angular-trello-api-client.js'
angularDateInterceptor = require 'angular-date-interceptor'
trello = require 'angular-trello'

require 'angular-material/angular-material.min.css'
require 'angular-material-data-table/dist/md-data-table.min.css'
require 'mdi/css/materialdesignicons.min.css'
require 'c3/c3.min.css'

require './styles/app.less'
require './styles/print.less'

require './models/0-module.coffee'
require './sprint/module.coffee'
require './problems/module.coffee'
require './organization/module.coffee'
require './common/module.coffee'
require './login/module.coffee'
require './feedback/module.coffee'
require './daily-report/module.coffee'
require './project/module.coffee'
require './policy/module.coffee'
require './indicators/module.coffee'
require './gmail-client/module.coffee'
require './admin/module.coffee'
# require './wait/module.coffee'


app = angular.module 'Scrumble', [
  ngResource
  ngRoute
  ngAnimate
  ngSanitize
  ngMaterial
  ngMessages
  mdDaraTable # soon included in ngMaterial
  ngUiRouter
  'LocalStorageModule'
  satellizer
  'permission'
  'trello-api-client'
  'angularDateInterceptor'
  'trello'

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
  # 'Scrumble.wait'
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
    key: TRELLO_KEY
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

module.exports = app