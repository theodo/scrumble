angular.module 'Scrumble.sprint'
.directive 'sprintDetails', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    sprint: '='
    sprints: '='
  controller: 'SprintDetailsCtrl'
