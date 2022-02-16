template = require './call-to-action.html'

angular.module 'Scrumble.feedback'
.directive 'feedback', ->
  restrict: 'E'
  template: template
  scope: {}
  controller: 'feedbackCallToActionCtrl'
