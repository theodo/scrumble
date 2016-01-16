angular.module 'Scrumble.sprint'
.controller 'EditSprintCtrl', (
  $scope
  $timeout
  $state
  TrelloClient
  project
  sprintUtils
  projectUtils
  sprint
  Project
  Sprint
) ->
  $scope.sprint = sprint

  closePromise = Sprint.closeActiveSprint project

  TrelloClient.get "/boards/#{project.boardId}/lists"
  .then (response) ->
    $scope.boardLists = response.data

  $scope.devTeam = projectUtils.getDevTeam project.team

  $scope.saveLabel = if $state.is 'tab.new-sprint' then 'Start the sprint' else 'Save'
  $scope.title = if $state.is 'tab.new-sprint' then 'NEW SPRINT' else 'EDIT SPRINT'

  $scope.save = ->
    if sprintUtils.isActivable($scope.sprint)
      closePromise.then ->
        $scope.sprint.save()

  $scope.activable = sprintUtils.isActivable($scope.sprint)
  $scope.activate = ->
    if sprintUtils.isActivable($scope.sprint)
      $scope.sprint.isActive = true
      $scope.sprint.save().then ->
        $state.go 'tab.board'

  $scope.checkSprint = (source) ->
    $scope.activable = sprintUtils.isActivable($scope.sprint)
    sprintUtils.ensureDataConsistency source, $scope.sprint, $scope.devTeam

  $scope.checkSprint 'team'
