angular.module 'Scrumble.settings'
.controller 'ProjectCtrl', (
  $scope
  TrelloClient
  Project
  ScrumbleUser2
  Organization
) ->

  $scope.isLoading = true

  TrelloClient.get('/members/me/organizations?fields=displayName').then (response) ->
    $scope.organizations = response.data
    organizationArray = _(response.data).map('id').uniq().value()
    TrelloClient.get('/members/me/boards?filter=open&fields=name,idOrganization,prefs').then (response) ->
      $scope.boards = _.map response.data, (board) ->
        if board.idOrganization == null
          board.idOrganization = 'myboards'
        else if !_.includes(organizationArray, board.idOrganization)
          board.idOrganization = 'otherboards'
        return board
      $scope.organizations = ([{id: 'myboards', displayName: 'Your boards'}]
      .concat $scope.organizations)
      .concat [{id: 'otherboards', displayName: 'Other organizations'}]
      $scope.isLoading = false

  Project.getUserProject().then (project) ->
    $scope.project = project
  .catch (err) ->
    $scope.project = Project.new()

  $scope.saving = false
  $scope.selectBoard = (boardId) ->
    return unless boardId?
    $scope.saving = true
    Project.query
      filter:
        where:
          boardId: boardId
    .$promise.then (response) ->
      return response[0] if response.length > 0
      console.debug "No project with boardId #{boardId} found. Creating a new one"
      project = Project.new()
      project.boardId = boardId
      board = _.find($scope.boards, (board) ->
        board.id is project.boardId
      )
      Organization.findOrCreate(board.idOrganization)
      .then (id) ->
        project.organizationId = id
        project.name = board?.name
        project.$save()
    .then (project) ->
      $scope.project = project
      $scope.saving = false
      ScrumbleUser2.setProject(projectId: project.id).$promise.then ->
        if not $scope.project.team?.length > 0
          $scope.$emit 'project:update', {nextState: 'tab.team', params: projectId: project.id}
        else
          $scope.$emit 'project:update', nextState: 'tab.bdc'
    .catch (err) ->
      $scope.project.boardId = null
      console.warn err
      $scope.saving = false
