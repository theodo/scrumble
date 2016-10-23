describe '[Controller] SelectProblemsCtrl', ->
  beforeEach module 'Scrumble.daily-report'

  $mdToast = null
  Problem = null
  markdownGenerator = null
  $rootScope = null
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
    markdownGenerator = _markdownGenerator_
    $rootScope = _$rootScope_
    $controller = _$controller_
    $q = _$q_
    $scope = $rootScope.$new()
    $scope.project = id: 1

  it 'should have instanciated controller and set first values', ->
    controller = $controller 'SelectProblemsCtrl',
      $scope: $scope
      Problem: Problem
      markdownGenerator: markdownGenerator
    expect(controller).toBeDefined()
    expect($scope.markdown).toEqual ''
    expect($scope.problems).toEqual []
    expect($scope.todaysProblems).toEqual []

  it 'should expose a list of problems', ->
    spyOn(Problem, 'query').and.returnValue $q.when ['problems']
    controller = $controller 'SelectProblemsCtrl',
      $scope: $scope
      Problem: Problem
      markdownGenerator: markdownGenerator
    $rootScope.$apply()
    expect(Problem.query).toHaveBeenCalled()
    expect($scope.problems).toEqual ['problems']

  it 'should generate markdown when updated', ->
    spyOn(markdownGenerator, 'problems').and.returnValue 'markdown'
    controller = $controller 'SelectProblemsCtrl',
      $scope: $scope
      Problem: Problem
      markdownGenerator: markdownGenerator
    $scope.update()
    expect(markdownGenerator.problems).toHaveBeenCalled()
    expect($scope.markdown).toEqual 'markdown'
