angular.module 'NotSoShitty.common'
.directive 'trelloAvatar', ->
  restrict: 'E'
  templateUrl: 'common/directives/trello-avatar/view.html'
  scope:
    size: '@'
    member: '='
    tooltip: '@'
  controller: 'TrelloAvatarCtrl'
