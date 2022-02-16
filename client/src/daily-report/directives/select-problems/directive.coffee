template = require './view.html'

angular.module 'Scrumble.daily-report'
.directive 'selectProblems', ->
  restrict: 'E'
  template: template
  scope:
    markdown: '='
    project: '='
  controller: 'SelectProblemsCtrl'
