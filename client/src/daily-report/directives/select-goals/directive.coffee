template = require './view.html'
require './style.less'

angular.module 'Scrumble.daily-report'
.directive 'selectGoals', ->
  restrict: 'E'
  template: template
  scope:
    markdown: '='
    project: '='
    sprint: '='
  controller: 'SelectGoalsCtrl'
