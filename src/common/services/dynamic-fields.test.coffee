describe 'dynamicFields', ->
  beforeEach module 'Scrumble.common'

  beforeEach inject (dynamicFields, $rootScope, trelloAuth, sprintUtils) ->
    @dynamicFields = dynamicFields
    @$rootScope = $rootScope
    @sprintUtils = sprintUtils
    trelloAuth.getTrelloInfo = ->
      then: (callback) ->
        callback
          fullName: 'Chuck Norris'

  describe 'getDictionary', ->
    it 'should return an object', ->
      expect(@dynamicFields.getAvailableFields()).toEqual jasmine.any(Array)

  describe 'render', ->
    it 'should replace sprint fields', (done) ->
      text = '{sprintNumber},{sprintGoal},{speed}'

      sprint =
        number: 10
        goal: 'Eat more carrots'
        resources:
          speed: 1.6666667

      @dynamicFields.ready sprint
      .then (builtDict) ->
        expect(builtDict['{sprintNumber}']).toBe sprint.number
        expect(builtDict['{sprintGoal}']).toBe sprint.goal
        expect(builtDict['{speed}']).toBe '1.7'
        done()
      @$rootScope.$apply()

    it 'should replace several times', (done) ->
      text = '{sprintNumber},{sprintNumber}'
      result = @dynamicFields.render text, {'{sprintNumber}': 10}
      expect(result).toBe '10,10'
      done()

    it 'should replace {today#YYYY-MM-DD}', (done) ->
      text = 'On {today#YYYY-MM-DD} I will eat 10 carrots. Yes, on {today#YYYY-MM-DD}'
      expected = 'On ' + moment().format('YYYY-MM-DD') + ' I will eat 10 carrots. Yes, on ' + moment().format('YYYY-MM-DD')

      result = @dynamicFields.render text, {}
      expect(result).toBe expected
      done()

    it 'should replace {yesterday#YYYY-MM-DD}', (done) ->
      text = 'On {yesterday#YYYY-MM-DD} I will eat 10 carrots. Yes, on {yesterday#YYYY-MM-DD}'
      expected = 'On ' + moment().subtract(1, 'days').format('YYYY-MM-DD') + ' I will eat 10 carrots. Yes, on ' + moment().subtract(1, 'days').format('YYYY-MM-DD')

      result = @dynamicFields.render text, {}
      expect(result).toBe expected
      done()

    it 'should replace {ahead:value1 behind:value2}', (done) ->
      text = '{ahead:Avance behind:Retard}: nombre de points d\'avance: {ahead:bien behind:pas bien}'
      expectedAhead = 'Avance: nombre de points d\'avance: bien'
      expectedBehind = 'Retard: nombre de points d\'avance: pas bien'

      @sprintUtils.isAhead = -> true
      result = @dynamicFields.render text, {}
      expect(result).toBe expectedAhead

      @sprintUtils.isAhead = -> undefined
      result = @dynamicFields.render text, {}
      expect(result).toBe expectedAhead

      @sprintUtils.isAhead = -> false
      result = @dynamicFields.render text, {}
      expect(result).toBe expectedBehind

      done()

    it 'should not raise error with undefined input', (done) ->
      text = undefined

      result = @dynamicFields.render text, {}
      expect(result).toBe ''
      done()
