angular.module 'NotSoShitty.settings'
.directive 'trelloAvatar', ->
  restrict: 'E'
  templateUrl: 'settings/directives/trello-avatar/view.html'
  scope:
    memberId: '@'
    size: '@'
  controller: 'TrelloAvatarCtrl'
