require './style.less'

angular.module 'Scrumble.common'
.directive 'trelloAvatar', ->
  restrict: 'E'
  template: require('./view.html')
  scope:
    size: '@'
    member: '='
    tooltip: '@'
  controller: 'TrelloAvatarCtrl'
