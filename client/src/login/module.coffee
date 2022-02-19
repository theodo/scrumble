angular.module 'Scrumble.login', [
  'LocalStorageModule'
  'satellizer'
  'ui.router'
  'permission'
  'trello-api-client'
  'trello'
]

require './config/google.coffee'
require './config/redirect.coffee'
require './config/routes.coffee'
require './config/trello.coffee'

require './directives/profil-info/controller.coffee'
require './directives/profil-info/directive.coffee'

require './services/access-token.coffee'
require './services/googleAuth.coffee'
require './services/interceptor.coffee'
require './services/trelloAuth.coffee'

require './states/trello/controller.coffee'

require './style.less'