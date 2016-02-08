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
  bdc
) ->

  $scope.editedSprint = sprint

  TrelloClient.get "/boards/#{$scope.project.boardId}/lists"
  .then (response) ->
    $scope.boardColumns = response.data

  $scope.devTeam = projectUtils.getDevTeam $scope.project.team

  $scope.saveLabel = if $state.is 'tab.new-sprint' then 'Start the sprint' else 'Save'
  $scope.title = if $state.is 'tab.new-sprint' then 'NEW SPRINT' else 'EDIT SPRINT'

  $scope.activable = sprintUtils.isActivable($scope.editedSprint)

  $scope.activate = ->
    $scope.project.save()
    if sprintUtils.isActivable($scope.editedSprint)
      $scope.editedSprint.isActive = true
      Sprint.closeActiveSprint $scope.project
      .then ->
        Sprint.save $scope.editedSprint
        .then (savedSprint) ->
          $scope.$emit 'sprint:update', nextState: 'tab.board'

  $scope.checkSprint = (source) ->
    $scope.activable = sprintUtils.isActivable($scope.editedSprint)
    sprintUtils.ensureDataConsistency source, $scope.editedSprint, $scope.devTeam

  $scope.checkSprint 'team'

  Sprint.getLastSpeeds($scope.project.objectId)
  .then (speedsInfo) ->
    formatedSpeedInfo = _ speedsInfo
      .filter (speedInfo) ->
        speedInfo.speed != '?'
      .map (speedInfo) ->
        "Sprint #{speedInfo.number}: #{speedInfo.speed}"
      .values()

    $scope.speedInfo =
      previousSpeeds: formatedSpeedInfo.join ', '

    sum = _.sum speedsInfo, (speedInfo) ->
      if _.isNumber parseFloat speedInfo.speed
        parseFloat speedInfo.speed
      else
        0
    speedAverage = sum / (formatedSpeedInfo.length or 1)
    if speedAverage > 0
      $scope.speedInfo.average = speedAverage.toFixed(1)
