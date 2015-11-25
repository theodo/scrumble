angular.module 'NotSoShitty.settings'
.directive 'selectPeople', ->
  restrict: 'E'
  templateUrl: 'settings/directives/select-people/view.html'
  scope:
    members: '='
    selectedMembers: '='
  controller: 'SelectPeopleCtrl'
