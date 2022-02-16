template = require './view.html'

angular.module 'Scrumble.daily-report'
.directive 'templateCallToAction', ->
  restrict: 'E'
  template: template
  controller: 'DefaultTemplateCtrl'
  scope:
    sections: '='
    section: '@'
