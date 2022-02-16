angular.module 'Scrumble.settings'
.directive 'projectWidget', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    project: '='
  controller: 'ProjectWidgetCtrl'
