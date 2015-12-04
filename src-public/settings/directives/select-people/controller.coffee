angular.module 'NotSoShitty.settings'
.controller 'SelectPeopleCtrl',
($scope) ->
  $scope.teamCheck ?= {}
  $scope.check = ->
    team = []
    for key, checked of $scope.teamCheck
      if checked
        team.push _.find $scope.members, (member) -> member.id
    $scope.selectedMembers = team

  $scope.$watch 'selectedMembers', (newVal) ->
    return unless newVal
    if newVal.length > 0
      $scope.teamCheck ?= {}
      for member in $scope.selectedMembers
        $scope.teamCheck[member.id] = true
    else $scope.teamCheck = {}
