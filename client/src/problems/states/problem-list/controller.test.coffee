describe '[Controller] ProblemListCtrl', ->
  beforeEach module 'Scrumble.problems'

  $mdDialog = null
  $rootScope = null
  $stateParams = null
  $controller = null
  $q = null

  beforeEach inject (_$mdDialog_, _$rootScope_, _$controller_, _$q_) ->
    $mdDialog = _$mdDialog_
    $rootScope = _$rootScope_
    $controller = _$controller_
    $q = _$q_

  it 'should expose $stateParams project', ->
    $scope = $rootScope.$new()
    controller = $controller 'ProblemListCtrl',
      $scope: $scope
      $stateParams:
        projectId: 1
    $scope.$digest()
    expect($scope.projectId).toEqual 1

  describe 'addProblem', ->

    it 'should call $mdDialog.show with an existing controller', ->
      spyOn($mdDialog, 'show').and.returnValue $q.when(null)
      $scope = $rootScope.$new()
      controller = $controller 'ProblemListCtrl',
        $scope: $scope
        $mdDialog: $mdDialog
      $scope.addProblem()
      expect($mdDialog.show).toHaveBeenCalled()
      dialog = $mdDialog.show.calls.argsFor(0)[0]

      dialogController = $controller dialog.controller,
        $scope: {}
        problem: {}
      expect(dialogController).toBeDefined()
