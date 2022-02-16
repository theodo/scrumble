angular.module 'Scrumble.common', [
  'trello-api-client'
  'ngMaterial'
  'ui.router'
  'Scrumble.sprint'
  'LocalStorageModule'
]

require './config/routes.coffee'
require './config/theodo-theme.coffee'

require './controllers/modalCtrl.coffee'

require './directives/dynamic-fields/directive.coffee'
require './directives/hc-chart/directive.coffee'
require './directives/round/directive.coffee'
require './directives/trello-avatar/avatar.coffee'
require './directives/trello-avatar/controller.coffee'
require './directives/trello-avatar/directive.coffee'

require './services/dialog.coffee'
require './services/dynamic-fields.coffee'
require './services/trello-utils.coffee'

require './states/controller.coffee'

require './styles/style.less'