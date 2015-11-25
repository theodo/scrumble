angular.module 'NotSoShitty.settings'
.directive 'resourcesByDay', ->
  restrict: 'E'
  templateUrl: 'settings/directives/resources-by-day/view.html'
  scope:
    members: '='
    matrix: '='
    days: '='
  controller: 'ResourcesByDayCtrl'
