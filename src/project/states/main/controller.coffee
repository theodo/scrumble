angular.module 'NotSoShitty.settings'
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
  user
  projectUtils
) ->
  $scope.boards = boards
  if user.project?
    project = user.project
  else
    project = new Project()

  $scope.project = project

  fetchBoardData = (boardId) ->
    $q.all [
      # the the list of columns
      TrelloClient.get("/boards/#{boardId}/lists")
      .then (response) ->
        $scope.boardColumns = response.data
      .catch (err) ->
        $scope.project.boardId = null
        console.warn "Could not fetch Trello board with id #{boardId}"
        console.log err

      # get the list of users
      TrelloClient.get("/boards/#{boardId}/members?fields=avatarHash,fullName,initials,username")
      .then (response) ->
        $scope.boardMembers = response.data
      .catch (err) ->
        $scope.project.boardId = null
        console.warn "Could not fetch Trello board members"
        console.log err

      # find if there is already a project for this board
      # otherwise create one
      Project.get boardId
      .then (response) ->
        return response if response?

        console.log "No project with boardId #{boardId} found. Creating a new one"
        project = new Project()
        project.boardId = boardId
        project.team = []
        project.save()
      .then (project) ->
        $scope.project = project
    ]

  if $scope.project.boardId?
    fetchBoardData $scope.project.boardId

  # Get board colums and members when board is set
  $scope.$watch 'project.boardId', (next, prev) ->
    return unless next? and next != prev
    fetchBoardData next

  $scope.delete = (member) ->
    _.remove $scope.project.team, member
  $scope.clearTeam = ->
    $scope.project.team = []
    $scope.save()

  $scope.saving = false
  $scope.save = ->
    $scope.saving = true
    return unless $scope.project.boardId?
    $scope.project.name = _.find(boards, (board) ->
      board.id == $scope.project.boardId
    ).name
    $scope.project.settings =
      bdcTitle: 'Sprint #{sprintNumber} - {sprintGoal} - Speed {speed}'
    $scope.project.save().then (p) ->
      user.project = p
      user.save().then ->
        $state.go 'tab.board'
      .catch ->
        $scope.saving = false
    .catch ->
      $scope.saving = false
  return
