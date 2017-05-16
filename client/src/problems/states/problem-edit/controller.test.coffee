describe '[Controller] AddProblemCtrl', ->
  beforeEach module 'Scrumble.problems'

  $mdDialog = null
  problem = null
  Problem = null
  Project = null
  $rootScope = null
  $stateParams = null
  $controller = null
  $q = null

  beforeEach inject (_$mdDialog_, _Problem_, _Project_, _$rootScope_, _$controller_, _$q_) ->
    Problem = _Problem_
    Project = _Project_
    $mdDialog = _$mdDialog_
    $rootScope = _$rootScope_
    $controller = _$controller_
    $q = _$q_

  it 'should expose the resolved problem', ->
    $scope = $rootScope.$new()
    problem = {}
    controller = $controller 'AddProblemCtrl',
      $scope: $scope
      problem: problem
    expect($scope.problem).toEqual problem
    expect($scope.problem.happenedDate).toEqual jasmine.any Date

  describe 'cancel', ->

    it 'should call $mdDialog.cancel', ->
      $scope = $rootScope.$new()
      spyOn($mdDialog, 'cancel')
      controller = $controller 'AddProblemCtrl',
        $scope: $scope
        problem: {}
        $mdDialog: $mdDialog
      $scope.cancel()
      expect($mdDialog.cancel).toHaveBeenCalled()

  describe 'save', ->

    it 'should set computable problem attributes', ->
      $scope = $rootScope.$new()
      spyOn(Problem, 'save').and.returnValue $q.when(null)
      controller = $controller 'AddProblemCtrl',
        $scope: $scope
        problem: {}
        Problem: Problem
        $stateParams:
          projectId: 1
      $scope.save({})
      expect(Problem.save).toHaveBeenCalledWith({projectId: 1, type: 'null'})

    it 'should call $mdDialog.hide', ->
      $scope = $rootScope.$new()
      spyOn(Problem, 'save').and.returnValue $q.when(null)
      spyOn($mdDialog, 'hide')
      spyOn(Project, 'get').and.returnValue $q.when(null)
      controller = $controller 'AddProblemCtrl',
        $scope: $scope
        problem: {}
        Problem: Problem
        $mdDialog: $mdDialog
      $scope.save({})
      $scope.$apply()
      expect($mdDialog.hide).toHaveBeenCalled()
