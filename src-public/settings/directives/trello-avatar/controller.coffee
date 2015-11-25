angular.module 'NotSoShitty.settings'
.controller 'TrelloAvatarCtrl',
(Avatar, $scope) ->
  $scope.size = '50' unless $scope.size
  $scope.$watch 'memberId', (memberId) ->
    return unless memberId
    Avatar.getMember $scope.memberId
    .then (member) ->
      $scope.member = member
