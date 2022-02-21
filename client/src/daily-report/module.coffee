angular.module 'Scrumble.daily-report', [
  'trello-api-client'
  'ui.router'
]

require './config/routes.coffee'
require './directives/default-template/controller.coffee'
require './directives/default-template/directive.coffee'

require './directives/dynamic-fields-call-to-action/controller.coffee'
require './directives/dynamic-fields-call-to-action/directive.coffee'

require './directives/dynamic-fields-dialog/controller.coffee'

require './directives/markdown-helper/directive.coffee'

require './directives/previous-goals/controller.coffee'
require './directives/previous-goals/directive.coffee'

require './directives/select-goals/controller.coffee'
require './directives/select-goals/directive.coffee'

require './directives/select-problems/controller.coffee'
require './directives/select-problems/directive.coffee'

require './services/bigben-report.coffee'
require './services/cards.coffee'
require './services/dailyCache.coffee'
require './services/default-template.coffee'
require './services/markdown-generator.coffee'
require './services/report-builder.coffee'

require './states/preview/controller.coffee'
require './states/template/controller.coffee'
