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

  colors = [
    '#8dd3c7'
    '#ffffb3'
    '#bebada'
    '#fb8072'
    '#80b1d3'
    '#fdb462'
    '#b3de69'
    '#fccde5'
    '#d9d9d9'
    '#bc80bd'
    '#ccebc5'
    '#ffed6f'
  ]
  getColor = (initials) ->
    hash = initials.charCodeAt(0)
    colors[hash%12]

  $scope.color = getColor $scope.member.initials
