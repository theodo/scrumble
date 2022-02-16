template = require './view.html'

angular.module 'Scrumble.daily-report'
.directive 'dynamicFieldsCallToAction', ->
  restrict: 'E'
  template: template
  controller: 'DynamicFieldsCallToActionCtrl'
