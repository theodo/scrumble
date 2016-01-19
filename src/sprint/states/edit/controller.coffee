angular.module 'Scrumble.sprint'
.controller 'EditSprintCtrl', (
  $scope
  $timeout
  $state
  TrelloClient
  project
  sprintUtils
  projectUtils
  Project
  Sprint
) ->
  console.log $scope.sprint
  TrelloClient.get "/boards/#{project.boardId}/lists"
  .then (response) ->
    $scope.boardLists = response.data

  $scope.devTeam = projectUtils.getDevTeam project.team

  $scope.saveLabel = if $state.is 'tab.new-sprint' then 'Start the sprint' else 'Save'
  $scope.title = if $state.is 'tab.new-sprint' then 'NEW SPRINT' else 'EDIT SPRINT'

  $scope.save = ->
    if sprintUtils.isActivable($scope.sprint)
      Sprint.closeActiveSprint project
      .then ->
        Sprint.save $scope.sprint

  $scope.activable = sprintUtils.isActivable($scope.sprint)
  $scope.activate = ->
    if sprintUtils.isActivable($scope.sprint)
      $scope.sprint.isActive = true
      Sprint.save $scope.sprint
      .then ->
        $state.go 'tab.board'

  $scope.checkSprint = (source) ->
    $scope.activable = sprintUtils.isActivable($scope.sprint)
    sprintUtils.ensureDataConsistency source, $scope.sprint, $scope.devTeam

  $scope.checkSprint 'team'
