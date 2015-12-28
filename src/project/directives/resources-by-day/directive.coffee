angular.module 'NotSoShitty.settings'
.directive 'resourcesByDay', ->
  restrict: 'E'
  templateUrl: 'project/directives/resources-by-day/view.html'
  scope:
    members: '='
    matrix: '='
    days: '='
    onUpdate: '&'
  controller: 'ResourcesByDayCtrl'
