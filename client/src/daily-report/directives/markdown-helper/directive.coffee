template = require './view.html'

angular.module 'Scrumble.daily-report'
.directive 'markdownHelper', ->
  restrict: 'E'
  template: template
