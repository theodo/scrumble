describe '[Controller] ProblemListCtrl', ->
  beforeEach module 'Scrumble.problems'

  it 'should define state with existing controllers', (done) ->
    inject ($state, $controller) ->
      state = $state.get('tab.problems')
      controller = $controller state.controller,
        $scope: {}
      expect(controller).toBeDefined()
      done()
