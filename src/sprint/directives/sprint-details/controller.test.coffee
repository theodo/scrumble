describe 'SprintDetailsCtrl', ->
  beforeEach module 'Scrumble.sprint'

  beforeEach inject ($controller, $mdDialog) ->
    @$controller = $controller
    @$mdDialog = $mdDialog

<<<<<<< Updated upstream
  # $scope.delete = (event) ->
  #   confirm = $mdDialog.confirm()
  #   .title 'Delete sprints'
  #   .textContent 'Are you sure you want to do what you\'re trying to do ?'
  #   .ariaLabel 'Delete sprints dialog'
  #   .targetEvent event
  #   .ok 'Delete'
  #   .cancel 'Cancel'
  #
  #   $mdDialog.show(confirm).then ->
  #     loadingToast.show 'deleting'
  #     $scope.sprint.destroy().then ->
  #       _.remove $scope.sprints, $scope.sprint
  #       loadingToast.hide 'deleting'

=======
>>>>>>> Stashed changes
  it 'should delete a sprint when calling $scope.delete', ->
    sprint =
      destroy: -> return

    $scope =
      sprint: sprint
      sprints: ['A', sprint, 'B']

    spyOn($scope.sprint, 'destroy').and.returnValue
      then: (callback) -> callback()

    loadingToastSpy =
      show: jasmine.createSpy 'show'
      hide: jasmine.createSpy 'hide'

    spyOn(@$mdDialog, 'show').and.returnValue
      then: (callback) -> callback()

    controller = @$controller 'SprintDetailsCtrl',
      $scope: $scope
      $state: null
      $mdMedia: null
      Sprint: null
      $mdDialog: @$mdDialog
      loadingToast: loadingToastSpy

    $scope.delete()

    expect(loadingToastSpy.show).toHaveBeenCalled()
    expect(loadingToastSpy.hide).toHaveBeenCalled()
    expect($scope.sprint.destroy).toHaveBeenCalled()
    expect($scope.sprints.length).toBe(2)
    expect($scope.sprints[0]).toBe('A')
    expect($scope.sprints[1]).toBe('B')
