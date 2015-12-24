describe 'trelloUtils', ->
  beforeEach module 'NotSoShitty.common'

  beforeEach inject (trelloUtils, TrelloClient, $q, $rootScope) ->
    @trelloUtils = trelloUtils
    @TrelloClient = TrelloClient
    @$q = $q
    @$rootScope = $rootScope

  describe 'getColumnPoints', ->
    it 'should be a function', ->
      expect(@trelloUtils.getColumnPoints).toEqual jasmine.any(Function)

    it 'should call TrelloClient.get and return 0 if no cards', ->
      deferred = @$q.defer()
      deferred.resolve data: []

      spyOn(@TrelloClient, 'get').and.returnValue deferred.promise
      result = null
      @trelloUtils.getColumnPoints().then (points) ->
        result = points
      @$rootScope.$digest()
      expect(@TrelloClient.get).toHaveBeenCalled()
      expect(result).toEqual 0

    it 'should sum the cards points', ->
      deferred = @$q.defer()
      deferred.resolve data: [
        name: '(0.5) Hello'
      ,
        name: '(3.5) Hello 2'
      ,
        name: 'Hello 3'
      ]

      spyOn(@TrelloClient, 'get').and.returnValue deferred.promise
      result = null
      @trelloUtils.getColumnPoints().then (points) ->
        result = points
      @$rootScope.$digest()
      expect(@TrelloClient.get).toHaveBeenCalled()
      expect(result).toEqual 4
