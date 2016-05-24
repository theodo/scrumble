angular.module 'Scrumble.indicators'
.directive 'celerityGraph', ->
  restrict: 'E'
  templateUrl: 'indicators/directives/celerity/view.html'
  controller: 'CelerityCtrl'
  scope:
    project: '='
