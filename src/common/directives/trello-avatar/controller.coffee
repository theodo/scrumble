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

  $scope.displayTooltip = if $scope.tooltip is 'true' then true else false

  colors = [
    '#fbb4ae'
    '#b3cde3'
    '#ccebc5'
    '#decbe4'
    '#fed9a6'
    '#ffffcc'
    '#e5d8bd'
    '#fddaec'
    '#f2f2f2'
  ]
  getColor = (initials) ->
    return colors[0] unless initials?
    hash = initials.charCodeAt(0)
    colors[hash%9]

  $scope.color = getColor $scope.member?.initials
