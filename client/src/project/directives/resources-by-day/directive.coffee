require('./style.less')

angular.module 'Scrumble.settings'
.directive 'resourcesByDay', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    members: '='
    timeboxActivated: '='
    matrix: '='
    days: '='
    onUpdate: '&'
  controller: 'ResourcesByDayCtrl'
