angular.module 'Scrumble.settings'
.controller 'TeamCtrl', (
  $scope
  TrelloClient
  Project
  project
) ->

  $scope.project = project

  $scope.delete = (member) ->
    _.remove $scope.project.team, member

  TrelloClient.get("/boards/#{$scope.project.boardId}/members?fields=avatarHash,fullName,initials,username")
  .then (response) ->
    $scope.boardMembers = response.data
  .catch (err) ->
    $scope.project.boardId = null
    console.warn "Could not fetch Trello board members"
    console.log err
