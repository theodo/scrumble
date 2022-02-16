require './style.less'

angular.module 'Scrumble.settings'
.directive 'selectPeople', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    members: '='
    selectedMembers: '='
  controller: 'SelectPeopleCtrl'
