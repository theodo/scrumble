describe 'trelloCards', ->
  beforeEach module 'NotSoShitty.daily-report'


  describe 'getTodoCards', ->
    beforeEach inject (trelloCards, TrelloClient, $q, $rootScope) ->
      @$q = $q
      @$rootScope = $rootScope
      @trelloCards = trelloCards
      @TrelloClient = TrelloClient

    it 'should return an array of cards', ->
      deferred = @$q.defer()
      deferred.resolve data: [{name: 'Card 1'}, {name: 'Card 2'}]

      spyOn(@TrelloClient, 'get').and.returnValue deferred.promise
      result = null
      @trelloCards.getTodoCards
        columnMapping:
          doing: ''
          sprint: ''
          blocked: ''
          toValidate: ''
      .then (cards) ->
        result = cards
      @$rootScope.$digest()
      expect(result.length).toBe 8
