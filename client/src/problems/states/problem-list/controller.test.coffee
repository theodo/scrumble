describe '[Controller] ProblemListCtrl', ->
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

  it 'should expose found problems', ->
    spyOn(Problem, 'query').and.returnValue $q.when([])
    $scope = $rootScope.$new()
    controller = $controller 'ProblemListCtrl',
      $scope: $scope
      Problem: Problem
    $scope.$digest()
    expect($scope.problems).toEqual []

  it 'should eventually set loading to false', ->
    spyOn(Problem, 'query').and.returnValue $q.when([])
    $scope = $rootScope.$new()
    controller = $controller 'ProblemListCtrl',
      $scope: $scope
      Problem: Problem
    $scope.$digest()
    expect($scope.loading).toEqual false

  it 'should search problems of current project', ->
    spyOn(Problem, 'query').and.returnValue $q.when([])
    $scope = $rootScope.$new()
    controller = $controller 'ProblemListCtrl',
      $scope: $scope
      Problem: Problem
      $stateParams:
        projectId: 1
    $scope.$digest()
    expect(Problem.query).toHaveBeenCalled()
    query = Problem.query.calls.argsFor(0)[0]
    expect(query.filter.where.projectId).toEqual 1

  describe 'editProblem and addProblem', ->

    it 'should call $mdDialog.show with an existing controller', ->
      spyOn($mdDialog, 'show').and.returnValue $q.when(null)
      $scope = $rootScope.$new()
      controller = $controller 'ProblemListCtrl',
        $scope: $scope
        Problem: Problem
        $mdDialog: $mdDialog
      $scope.editProblem()
      expect($mdDialog.show).toHaveBeenCalled()
      dialog = $mdDialog.show.calls.argsFor(0)[0]

      dialogController = $controller dialog.controller,
        $scope: {}
        problem: {}
      expect(dialogController).toBeDefined()

  describe 'deleteProblem', ->

    it 'should ask a confirmation before deleting', ->
      spyOn($mdDialog, 'show').and.returnValue $q.when(null)
      spyOn($mdDialog, 'confirm').and.callThrough()
      spyOn(Problem, 'query').and.returnValue $q.when([])
      $scope = $rootScope.$new()
      controller = $controller 'ProblemListCtrl',
        $scope: $scope
        Problem: Problem
        $mdDialog: $mdDialog
      problem =
        $delete: ->
      spyOn(problem, '$delete').and.returnValue $q.when(null)
      $scope.deleteProblem(problem)
      expect($mdDialog.show).toHaveBeenCalled()
      expect($mdDialog.confirm).toHaveBeenCalled()
      expect(problem.$delete).not.toHaveBeenCalled()
      $scope.$digest()
      expect(problem.$delete).toHaveBeenCalled()
