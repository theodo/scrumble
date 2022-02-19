angular.module 'Scrumble.sprint'
.controller 'EditSprintCtrl', ['$scope', '$state', '$mdToast', 'TrelloClient', 'sprintUtils', 'projectUtils', 'Project', 'Sprint', 'sprint', 'bdc', (
  $scope
  $state
  $mdToast
  TrelloClient
  sprintUtils
  projectUtils
  Project
  Sprint
  sprint
  bdc
) ->

  $scope.editedSprint = sprint

  getBoardColumns = ->
    TrelloClient.get "/boards/#{$scope.project.boardId}/lists"
    .then (response) ->
      $scope.boardColumns = response.data

  getBoardColumns()

  $scope.refresh = ->
    toast = $mdToast.simple()
      .textContent 'Refresh'
      .position 'bottom right'
      .hideDelay 10000
    $mdToast.show toast
    getBoardColumns().then ->
      $mdToast.hide()

  $scope.editedSprint.resources.team ?= $scope.project.team
  $scope.devTeam = projectUtils.getDevTeam $scope.editedSprint.resources.team

  $scope.saveLabel = if $state.is 'tab.new-sprint' then 'Start the sprint' else 'Save'
  $scope.title = if $state.is 'tab.new-sprint' then 'NEW SPRINT' else 'EDIT SPRINT'

  $scope.activable = sprintUtils.isActivable($scope.editedSprint)

  $scope.activate = ->
    $scope.project.$update()
    if sprintUtils.isActivable($scope.editedSprint)
      Sprint.save($scope.editedSprint).then ->
        $scope.$emit 'sprint:update', nextState: 'tab.bdc'

  $scope.checkSprint = (source) ->
    $scope.activable = sprintUtils.isActivable($scope.editedSprint)
    sprintUtils.ensureDataConsistency source, $scope.editedSprint, $scope.devTeam

  $scope.checkSprint 'team'
]
