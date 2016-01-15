angular.module 'Scrumble.feedback'
.directive 'feedback', ->
  restrict: 'E'
  templateUrl: 'feedback/directives/call-to-action.html'
  scope: {}
  controller: 'feedbackCallToActionCtrl'
