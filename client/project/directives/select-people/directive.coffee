angular.module 'Scrumble.settings'
.directive 'selectPeople', ->
  restrict: 'E'
  templateUrl: 'project/directives/select-people/view.html'
  scope:
    members: '='
    selectedMembers: '='
  controller: 'SelectPeopleCtrl'
