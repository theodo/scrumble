angular.module 'Scrumble.problems', ['Scrumble.common']

require './components/problems-list/directive.coffee'
require './components/tag-input/directive.coffee'
require './config/routes.coffee'
require './services/tag-repository.coffee'
require './states/problem-edit/controller.coffee'
require './states/problem-list/controller.coffee'