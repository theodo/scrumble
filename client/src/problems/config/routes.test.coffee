describe '[Config] Problem routes', ->
  beforeEach module 'Scrumble.problems'

  it 'should define state with existing controllers', ->
    inject ($state, $controller, $rootScope) ->
      state = $state.get('tab.problems')
      controller = $controller state.controller,
        $scope: $rootScope.$new()
      expect(controller).toBeDefined()
