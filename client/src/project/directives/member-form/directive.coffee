require './style.less'

angular.module 'Scrumble.settings'
.directive 'memberForm', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    member: '='
    delete: '&'
  controller: 'MemberFormCtrl'
