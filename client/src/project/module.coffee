angular.module 'Scrumble.settings', [
  'Scrumble.common'
  'Scrumble.daily-report'
]

require './config/routes.coffee'
require './directives/member-form/controller.coffee'
require './directives/member-form/directive.coffee'
require './directives/project-widget/controller.coffee'
require './directives/project-widget/directive.coffee'
require './directives/resources-by-day/controller.coffee'
require './directives/resources-by-day/directive.coffee'
require './directives/select-people/controller.coffee'
require './directives/select-people/directive.coffee'
require './directives/speed-average/directive.coffee'
require './directives/speed-info/directive.coffee'

require './services/projectUtils.coffee'
require './services/speed.coffee'
require './services/team-validator.coffee'

require './states/main/controller.coffee'
require './states/team/controller.coffee'

require './states/main/style.less'