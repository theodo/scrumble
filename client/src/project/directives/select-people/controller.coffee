angular.module 'Scrumble.settings'
.controller 'SelectPeopleCtrl',
($scope) ->
  $scope.teamCheck ?= {}

  $scope.toggle = (member) ->
    if member.id in (m.id for m in $scope.selectedMembers)
      _.remove $scope.selectedMembers, (m) ->
        m.id == member.id
      $scope.teamCheck[member.id] = false
    else
      $scope.selectedMembers.push member
      $scope.teamCheck[member.id] = true

  $scope.$watch 'selectedMembers', (newVal) ->
    return unless newVal
    $scope.teamCheck = {}
    if newVal.length > 0
      for member in newVal
        $scope.teamCheck[member.id] = true
  , true
