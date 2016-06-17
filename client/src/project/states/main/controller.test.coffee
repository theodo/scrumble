describe 'projectCtrl', ->
  beforeEach module 'Scrumble.settings'

  TrelloClient = null
  $q = null
  $controller = null
  $rootScope = null
  Project = null

  beforeEach inject (_TrelloClient_, _$q_, _$controller_, _$rootScope_, _Project_) ->
    TrelloClient = _TrelloClient_
    $q = _$q_
    $controller = _$controller_
    $rootScope = _$rootScope_
    Project = _Project_
    spyOn(Project, 'getUserProject').and.returnValue $q.when {}

  it 'should expose an empty board list in the scope', ->
    spyOn(TrelloClient, 'get').and.returnValue $q.when data: []
    $scope = $rootScope.$new()
    controller = $controller 'ProjectCtrl',
      $scope: $scope
      TrelloClient: TrelloClient
    $scope.$digest()
    expect($scope.boards).toEqual []

  it 'should expose the boards and the organizations in the scope', ->
    spyOn(TrelloClient, 'get').and.callFake (path) ->
      if _.startsWith(path, '/members/me/boards')
        return $q.when data: [{idOrganization: null, name:'board1'}, {idOrganization: 'abcde1', name:'board2'}, {idOrganization: 'notmyorganization', name:'board3'}]
      else
        return $q.when data: [{id: 'abcde1', displayName: 'Abcde 1'}]
    $scope = $rootScope.$new()
    controller = $controller 'ProjectCtrl',
      $scope: $scope
      TrelloClient: TrelloClient
    $scope.$digest()
    expect($scope.boards).toEqual [{idOrganization: 'myboards', name:'board1'}, {idOrganization: 'abcde1', name:'board2'}, {idOrganization: 'otherboards', name:'board3'}]
    expect($scope.organizations).toEqual [{id: 'myboards', displayName:'Your boards'}, {id: 'abcde1', displayName:'Abcde 1'}, {id: 'otherboards', displayName: 'Other organizations'}]
