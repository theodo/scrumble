describe '[Controller] RedTrayListCtrl', ->
  beforeEach module 'Scrumble.problems'

  $mdDialog = null
  problem = null
  Problem = null
  $rootScope = null
  $stateParams = null
  $controller = null
  $q = null

  beforeEach inject (_$mdDialog_, _Problem_, _$rootScope_, _$controller_, _$q_) ->
    Problem = _Problem_
    $mdDialog = _$mdDialog_
    $rootScope = _$rootScope_
    $controller = _$controller_
    $q = _$q_

  it 'should expose the found pieces', ->
    spyOn(Problem, 'query').and.returnValue $q.when([])
    $scope = $rootScope.$new()
    controller = $controller 'RedTrayListCtrl',
      $scope: $scope
      Problem: Problem
    $scope.$digest()
    expect($scope.pieces).toEqual []

  it 'should eventually set loading to false', ->
    spyOn(Problem, 'query').and.returnValue $q.when([])
    $scope = $rootScope.$new()
    controller = $controller 'RedTrayListCtrl',
      $scope: $scope
      Problem: Problem
    $scope.$digest()
    expect($scope.loading).toEqual false

  it 'should search pieces of current project', ->
    spyOn(Problem, 'query').and.returnValue $q.when([])
    $scope = $rootScope.$new()
    controller = $controller 'RedTrayListCtrl',
      $scope: $scope
      Problem: Problem
      $stateParams:
        projectId: 1
    $scope.$digest()
    expect(Problem.query).toHaveBeenCalled()
    query = Problem.query.calls.argsFor(0)[0]
    expect(query.filter.where.projectId).toEqual 1

  describe 'editPiece and addPiece', ->

    it 'should call $mdDialog.show with an existing controller', ->
      spyOn($mdDialog, 'show').and.returnValue $q.when(null)
      $scope = $rootScope.$new()
      controller = $controller 'RedTrayListCtrl',
        $scope: $scope
        Problem: Problem
        $mdDialog: $mdDialog
      $scope.editPiece()
      expect($mdDialog.show).toHaveBeenCalled()
      dialog = $mdDialog.show.calls.argsFor(0)[0]

      dialogController = $controller dialog.controller,
        $scope: {}
        problem: {}
      expect(dialogController).toBeDefined()
