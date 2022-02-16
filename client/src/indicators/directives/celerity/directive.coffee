angular.module 'Scrumble.indicators'
.directive 'celerityGraph', ->
  restrict: 'E'
  template: require('./view.html')
  controller: 'CelerityCtrl'
  scope:
    project: '='
