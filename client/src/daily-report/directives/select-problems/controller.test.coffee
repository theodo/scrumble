describe '[Controller] SelectProblemsCtrl', ->
  beforeEach module 'Scrumble.daily-report'

  $mdToast = null
  Problem = null
  markdownGenerator = null
  $rootScope = null
  $stateParams = null
  $controller = null
  $scope = null
  $q = null
  deferred = null

  beforeEach inject (
  _$mdToast_
  _Problem_
  _$rootScope_
  _$controller_
  _$q_
  _markdownGenerator_
  ) ->
    Problem = _Problem_
    $mdToast = _$mdToast_
    markdownGenerator = _markdownGenerator_
    $rootScope = _$rootScope_
    $controller = _$controller_
    $q = _$q_
    $scope = $rootScope.$new()
    $scope.project = id: 1
    deferred = _$q_.defer()

  it 'should have instanciated controller and set first values', ->
    controller = $controller 'SelectProblemsCtrl',
      $scope: $scope
      $mdToast: $mdToast
      Problem: Problem
      markdownGenerator: markdownGenerator
    expect(controller).toBeDefined()
    expect($scope.markdown).toEqual ''
    expect($scope.problems).toEqual []
    expect($scope.todaysProblems).toEqual []

  it 'should expose a list of problems', ->
    deferred.resolve ['problems']
    spyOn(Problem, 'getWithOwnerAndCard').and.returnValue deferred.promise
    controller = $controller 'SelectProblemsCtrl',
      $scope: $scope
      $mdToast: $mdToast
      Problem: Problem
      markdownGenerator: markdownGenerator
    $rootScope.$apply()
    expect(Problem.getWithOwnerAndCard).toHaveBeenCalled()
    expect($scope.problems).toEqual ['problems']

  it 'should generate markdown when updated', ->
    spyOn(markdownGenerator, 'problems').and.returnValue 'markdown'
    controller = $controller 'SelectProblemsCtrl',
      $scope: $scope
      $mdToast: $mdToast
      Problem: Problem
      markdownGenerator: markdownGenerator
    $scope.update()
    expect(markdownGenerator.problems).toHaveBeenCalled()
    expect($scope.markdown).toEqual 'markdown'
