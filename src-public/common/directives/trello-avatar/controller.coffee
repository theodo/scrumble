angular.module 'NotSoShitty.common'
.controller 'TrelloAvatarCtrl',
(Avatar, $scope) ->
  $scope.size = '50' unless $scope.size
  $scope.$watch 'member', (member) ->
    unless member?
      return $scope.hash = null
    if member.uploadedAvatarHash
      $scope.hash = member.uploadedAvatarHash
    else if member.avatarHash
      $scope.hash = member.avatarHash
    else
      $scope.hash = null
