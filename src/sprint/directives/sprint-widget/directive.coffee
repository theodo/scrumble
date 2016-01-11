angular.module 'NotSoShitty.sprint'
.directive 'sprintWidget', ->
  restrict: 'E'
  templateUrl: 'sprint/directives/sprint-widget/view.html'
  scope:
    project: '='
    sprint: '='
  controller: 'SprintWidgetCtrl'
