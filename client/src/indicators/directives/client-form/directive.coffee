require './style.less'

angular.module 'Scrumble.indicators'
.directive 'clientForm', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    sprint: '='
    project: '='
    template: '='
  controller: 'ClientFormCtrl'
