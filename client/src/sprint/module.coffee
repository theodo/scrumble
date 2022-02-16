angular.module 'Scrumble.sprint', [
  'ui.router'
  'ngMaterial'
  'Scrumble.models'
]

require './config/routes.coffee'
require './directives/burndown/directive.coffee'
require './directives/sprint-details/directive.coffee'
require './directives/sprint-widget/controller.coffee'
require './directives/sprint-widget/directive.coffee'
require './services/bdc-data-provider.coffee'
require './services/bdc.coffee'
require './services/sprint.coffee'
require './states/bdc/controller.coffee'
require './states/edit/controller.coffee'
require './states/list/controller.coffee'
