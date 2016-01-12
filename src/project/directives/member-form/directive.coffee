angular.module 'NotSoShitty.settings'
.directive 'memberForm', ->
  restrict: 'E'
  templateUrl: 'project/directives/member-form/view.html'
  scope:
    member: '='
    delete: '&'
  controller: 'MemberFormCtrl'
