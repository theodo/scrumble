describe 'SprintDetailsCtrl', ->
  beforeEach module 'Scrumble.sprint'

  beforeEach inject ($controller, $mdDialog, Sprint) ->
    @$controller = $controller
    @$mdDialog = $mdDialog
    @Sprint = Sprint

  it 'should delete a sprint when calling $scope.delete', ->
    spyOn(@Sprint, 'delete').and.returnValue
      then: (callback) -> callback()
    sprint =
      number: 1

    $scope =
      sprint: sprint
      sprints: ['A', sprint, 'B']

    loadingToastSpy =
      show: jasmine.createSpy 'show'
      hide: jasmine.createSpy 'hide'

    spyOn(@$mdDialog, 'show').and.returnValue
      then: (callback) -> callback()

    controller = @$controller 'SprintDetailsCtrl',
      $scope: $scope
      $state: null
      $mdMedia: null
      Sprint: @Sprint
      $mdDialog: @$mdDialog
      loadingToast: loadingToastSpy

    $scope.delete($scope.sprint, null)

    expect(loadingToastSpy.show).toHaveBeenCalled()
    expect(loadingToastSpy.hide).toHaveBeenCalled()
    expect(@Sprint.delete).toHaveBeenCalled()
    expect($scope.sprints.length).toBe(2)
    expect($scope.sprints[0]).toBe('A')
    expect($scope.sprints[1]).toBe('B')

  it 'should go to sprint indicator state when calling $scope.indicators', ->
    sprint =
      id: 'ABCD'

    $scope =
      sprint: sprint
      sprints: ['A', sprint, 'B']

    $state =
      go: null

    spyOn($state, 'go')

    controller = @$controller 'SprintDetailsCtrl',
      $scope: $scope
      $state: $state
      $mdMedia: null
      Sprint: null
      $mdDialog: null
      loadingToast: null

    $scope.indicators sprint

    expect($state.go).toHaveBeenCalledWith('tab.indicators', {sprintId: 'ABCD'})
