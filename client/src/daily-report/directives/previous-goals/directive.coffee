template = require './view.html'

angular.module 'Scrumble.daily-report'
.directive 'previousGoals', ->
  restrict: 'E'
  template: template
  scope:
    markdown: '='
    sprint: '='
  controller: 'PreviousGoalsCtrl'
