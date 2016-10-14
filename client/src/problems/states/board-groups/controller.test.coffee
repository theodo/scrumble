fdescribe '[Controller] BoardGroupCtrl', ->
  beforeEach module 'Scrumble.problems'
  beforeEach module 'app.templates'

  $mdDialog = null
  $rootScope = null
  $controller = null
  $q = null
  $scope = null
  TrelloClient = null
  BoardGroup = null
  $templateCache = null

  beforeEach inject (_$mdDialog_, _$rootScope_, _$controller_, _$q_, _TrelloClient_, _BoardGroup_, _$templateCache_) ->
    $mdDialog = _$mdDialog_
    $rootScope = _$rootScope_
    $controller = _$controller_
    $q = _$q_
    $templateCache = _$templateCache_
    TrelloClient = _TrelloClient_
    BoardGroup = _BoardGroup_
    $scope = $rootScope.$new()

  it 'should fetch boards from Trello', ->
    boards = []
    spyOn(TrelloClient, 'get').and.returnValue $q.when(data: boards)
    spyOn(BoardGroup, 'mine').and.returnValue $q.when(null)

    controller = $controller 'BoardGroupCtrl',
      $scope: $scope
      TrelloClient: TrelloClient

    expect(TrelloClient.get).toHaveBeenCalled()
    endpoint = TrelloClient.get.calls.argsFor(0)[0]
    expect(_.startsWith(endpoint, '/members/me/boards')).toEqual(true)
    $scope.$digest()
    expect($scope.boards).toEqual(boards)

  describe 'edit', ->
    it 'should open a dialog with an existing template and controller', ->
      boards = []
      spyOn(TrelloClient, 'get').and.returnValue $q.when(data: boards)
      spyOn($mdDialog, 'show').and.returnValue $q.when(null)

      controller = $controller 'BoardGroupCtrl',
        $scope: $scope
        TrelloClient: TrelloClient
        $mdDialog: $mdDialog

      $scope.edit(null)
      expect($mdDialog.show).toHaveBeenCalled()
      config = $mdDialog.show.calls.argsFor(0)[0]
      controller = $controller(config.controller, {
        group: BoardGroup.new()
        boards: boards
        $scope: {}
      })
      expect(controller).toBeDefined()
      expect($templateCache.get(config.templateUrl)).toBeDefined()

  describe 'delete', ->

    it 'should call BoardGroup.delete with the given group id', ->
      boards = []
      spyOn(TrelloClient, 'get').and.returnValue $q.when(data: boards)
      spyOn(BoardGroup, 'mine').and.returnValue $q.when(null)
      spyOn(BoardGroup, 'delete').and.returnValue $q.when(null)
      spyOn($mdDialog, 'show').and.returnValue $q.when(null)

      controller = $controller 'BoardGroupCtrl',
        $scope: $scope
        TrelloClient: TrelloClient
        $mdDialog: $mdDialog
        BoardGroup: BoardGroup

      group =
        id: 1
      $scope.delete(group, null)
      $scope.$digest()
      expect(BoardGroup.delete).toHaveBeenCalledWith(id: group.id)
