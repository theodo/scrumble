angular.module 'NotSoShitty.bdc'
.controller 'EditSprintCtrl', (
  $scope
  $timeout
  $state
  TrelloClient
  project
  sprintUtils
  sprint
  Project
) ->
  $scope.sprint = sprint

  TrelloClient.get "/boards/#{project.boardId}/lists"
  .then (response) ->
    $scope.boardLists = response.data

  $scope.devTeam = project.team?.dev

  $scope.saveLabel = if $state.is 'tab.new-sprint' then 'Start the sprint' else 'Save'
  $scope.title = if $state.is 'tab.new-sprint' then 'NEW SPRINT' else 'EDIT SPRINT'

  $scope.save = ->
    if sprintUtils.isActivable($scope.sprint)
      $scope.sprint.save()

  $scope.activable = sprintUtils.isActivable($scope.sprint)
  $scope.activate = ->
    if sprintUtils.isActivable($scope.sprint)
      $scope.sprint.isActive = true
      $scope.sprint.save().then ->
        $state.go 'tab.current-sprint'

  $scope.checkSprint = (source) ->
    $scope.activable = sprintUtils.isActivable($scope.sprint)
    sprintUtils.ensureDataConsistency source, $scope.sprint, project?.team?.dev

  $scope.checkSprint 'team'
