require './style.less'

angular.module 'Scrumble.sprint'
.directive 'sprintWidget', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    project: '='
    sprint: '='
  controller: 'SprintWidgetCtrl'
