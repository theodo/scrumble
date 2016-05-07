angular.module 'Scrumble.settings'
.controller 'TeamCtrl', (
  $mdDialog
  $scope
  TrelloClient
  Project
  project
) ->

  $scope.project = project

  TrelloClient.get("/boards/#{$scope.project.boardId}/members?fields=avatarHash,fullName,initials,username")
  .then (response) ->
    $scope.boardMembers = response.data
  .catch (err) ->
    $scope.project.boardId = null
    console.warn "Could not fetch Trello board members"
    console.log err

  $scope.delete = (member) ->
    _.remove $scope.project.team, member

  $scope.saving = false
  $scope.save = ->
    $scope.saving = true
    if not $scope.project.team.length > 0
      $mdDialog.show($mdDialog.alert()
      .clickOutsideToClose(true)
      .textContent('Please select your team!')
      .ariaLabel('Alert dialog team setting')
      .ok('Got it!'))
      $scope.saving = false
    else if roleSearch ['dev', 'archi'], $scope.project.team
      $scope.project.save().then ->
        $scope.saving = false
        $scope.$emit 'project:update', nextState:'tab.board'
    else
      $mdDialog.show($mdDialog.alert()
        .clickOutsideToClose(true)
        .textContent('Please select at list one dev or archi dev in your team.')
        .ariaLabel('Alert dialog team setting')
        .ok('Got it!'))
      $scope.saving = false

  roleSearch = (roleKeys, myArray) ->
    i = 0
    while i < myArray.length
      if myArray[i].role in roleKeys
        return true
      i++
