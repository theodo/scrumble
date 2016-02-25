angular.module 'Scrumble.settings'
.controller 'ProjectCtrl', (
  $location
  $mdToast
  $scope
  $state
  $timeout
  $q
  boards
  TrelloClient
  localStorageService
  Project
  Sprint
  user
  projectUtils
) ->
  $scope.boards = boards
  if user.project?
    project = user.project
  else
    project = new Project()
  $scope.project = project

  $scope.saving = false
  $scope.selectedItemChange = (boardId) ->
    $scope.saving = true
    Project.get boardId
    .then (response) ->
      return response if response?
      console.log "No project with boardId #{boardId} found. Creating a new one"
      project = new Project()
      project.boardId = boardId
      project.team = []
      project.settings ?= {}
      project.settings.bdcTitle = 'Sprint #{sprintNumber} - {sprintGoal} - Speed {speed}'
      project.name = _.find(boards, (board) ->
        board.id == project.boardId
      ).name
      project.save()
    .then (project) ->
      $scope.project = project
      $scope.saving = false
      user.project = project
      user.save().then ->
        if not $scope.project.team.length > 0
          $scope.$emit 'project:update', nextState:'tab.team'
        else
          $scope.$emit 'project:update', nextState:'tab.board'
    .catch (err) ->
      $scope.project.boardId = null
      console.warn "Could not fetch Trello board members"
      console.log err
      $scope.saving = false
