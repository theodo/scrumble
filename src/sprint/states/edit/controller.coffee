angular.module 'Scrumble.sprint'
.controller 'EditSprintCtrl', (
  $scope
  $state
  TrelloClient
  sprintUtils
  projectUtils
  Project
  Sprint
  sprint
) ->
  $scope.editedSprint = sprint

  TrelloClient.get "/boards/#{$scope.project.boardId}/lists"
  .then (response) ->
    $scope.boardLists = response.data

  $scope.devTeam = projectUtils.getDevTeam $scope.project.team

  $scope.saveLabel = if $state.is 'tab.new-sprint' then 'Start the sprint' else 'Save'
  $scope.title = if $state.is 'tab.new-sprint' then 'NEW SPRINT' else 'EDIT SPRINT'

  $scope.save = ->
    if sprintUtils.isActivable($scope.editedSprint)
      Sprint.closeActiveSprint $scope.project
      .then ->
        Sprint.save $scope.editedSprint

  $scope.activable = sprintUtils.isActivable($scope.editedSprint)
  $scope.activate = ->
    if sprintUtils.isActivable($scope.editedSprint)
      $scope.sprint.isActive = true
      Sprint.save $scope.editedSprint
      .then ->
        $state.go 'tab.board'

  $scope.checkSprint = (source) ->
    $scope.activable = sprintUtils.isActivable($scope.editedSprint)
    sprintUtils.ensureDataConsistency source, $scope.editedSprint, $scope.devTeam

  $scope.checkSprint 'team'
