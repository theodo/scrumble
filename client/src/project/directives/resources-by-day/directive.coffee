angular.module 'Scrumble.settings'
.directive 'resourcesByDay', ->
  restrict: 'E'
  templateUrl: 'project/directives/resources-by-day/view.html'
  scope:
    members: '='
    timeboxActivated: '='
    matrix: '='
    days: '='
    onUpdate: '&'
  controller: 'ResourcesByDayCtrl'
