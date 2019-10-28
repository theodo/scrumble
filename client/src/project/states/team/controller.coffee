angular.module 'Scrumble.settings'
.controller 'TeamCtrl', (
  $mdDialog
  $scope
  $stateParams
  TrelloClient
  TeamValidator
  Project
) ->

  Project.getUserProject()
  .then (project) ->
    $scope.project = project
  .then ->
    TrelloClient.get("/boards/#{$scope.project.boardId}/members?fields=avatarHash,fullName,initials,username")
  .then (response) ->
    $scope.boardMembers = response.data
  .catch (err) ->
    console.warn err

  $scope.delete = (member) ->
    _.remove $scope.project.team, member

  $scope.saving = false
  $scope.save = ->
    $scope.saving = true

    cause = TeamValidator.isValide($scope.project.team)
    unless cause is true
      $scope.saving = false
      return $mdDialog.show(TeamValidator.buildAlert(cause))

    $scope.project.$update().then ->
      $scope.saving = false
      $scope.$emit 'project:update', nextState: 'tab.bdc'
