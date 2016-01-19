angular.module 'Scrumble.sprint'
.directive 'sprintDetails', ->
  restrict: 'E'
  templateUrl: 'sprint/directives/sprint-details/view.html'
  scope:
    sprint: '='
    sprints: '='
  controller: 'SprintDetailsCtrl'
