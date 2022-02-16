require './style.less'

angular.module 'Scrumble.indicators'
.directive 'checklist', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    sprint: '='
    template: '='
  controller: 'ChecklistCtrl'
