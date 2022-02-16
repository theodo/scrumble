angular.module 'Scrumble.organization', [
  'ui.router'
  'trello-api-client'
  'Scrumble.problems'
]

require './config/routes.coffee'
require './states/problems/controller.coffee'
require './states/settings/controller.coffee'