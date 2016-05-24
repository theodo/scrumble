angular.module 'Scrumble.daily-report'
.directive 'templateCallToAction', ->
  restrict: 'E'
  templateUrl: 'daily-report/directives/default-template/view.html'
  controller: 'DefaultTemplateCtrl'
  scope:
    sections: '='
    section: '@'
