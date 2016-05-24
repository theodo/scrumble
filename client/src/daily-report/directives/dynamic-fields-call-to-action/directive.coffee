angular.module 'Scrumble.daily-report'
.directive 'dynamicFieldsCallToAction', ->
  restrict: 'E'
  templateUrl: 'daily-report/directives/dynamic-fields-call-to-action/view.html'
  controller: 'DynamicFieldsCallToActionCtrl'
