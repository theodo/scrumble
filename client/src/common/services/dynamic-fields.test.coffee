describe 'dynamicFields', ->
  beforeEach module 'Scrumble.common'

  beforeEach inject (
    dynamicFields,
    $rootScope,
    sprintUtils,
    trelloUtils
    TrelloClient
  ) ->
    @dynamicFields = dynamicFields
    @$rootScope = $rootScope
    @sprintUtils = sprintUtils
    @trelloUtils = trelloUtils
    TrelloClient.get = ->
      then: (callback) ->
        callback
          data: fullName: 'Chuck Norris'

  describe 'getDictionary', ->
    it 'should return an object', ->
      expect(@dynamicFields.getAvailableFields()).toEqual jasmine.any(Array)

    it 'should returns an array of objects with uniq icons', ->
      fields = @dynamicFields.getAvailableFields()
      expect(_.uniq(fields, 'icon').length).toEqual fields.length

  describe 'render', ->
    it 'should replace sprint fields', (done) ->
      text = '{sprintNumber},{sprintGoal},{speed},{total}'

      sprint =
        number: 10
        goal: 'Eat more carrots'
        resources:
          speed: 1.6666667
          totalPoints: 24.199

      @dynamicFields.ready sprint
      .then (builtDict) ->
        expect(builtDict['{sprintNumber}']).toBe sprint.number
        expect(builtDict['{sprintGoal}']).toBe sprint.goal
        expect(builtDict['{speed}']).toBe '1.7'
        expect(builtDict['{total}']).toBe '24.2'
        done()
      @$rootScope.$apply()

    it 'should replace {me}', (done) ->
      @dynamicFields.ready()
      .then (builtDict) ->
        expect(builtDict['{me}']).toBe 'Chuck Norris'
        done()
      @$rootScope.$apply()

    it 'should replace {toValidate} and {blocked}', (done) ->
      project =
        columnMapping:
          toValidate: 'A'
          blocked: 'B'
      points =
        'A': 3.5
        'B': 0
      spyOn(@trelloUtils, 'getColumnPoints').and.callFake (id) -> points[id]
      @dynamicFields.ready(null, project)
      .then (builtDict) ->
        expect(builtDict['{toValidate}']).toBe 3.5
        expect(builtDict['{blocked}']).toBe 0
        done()
      @$rootScope.$apply()

    it 'should return undefined if {toValidate} and {blocked} are undefined', (done) ->
      @dynamicFields.ready()
      .then (builtDict) ->
        expect(builtDict['{toValidate}']).toBe undefined
        expect(builtDict['{blocked}']).toBe undefined
        done()
      @$rootScope.$apply()

    it 'should replace {done} and {gap}', (done) ->
      sprint =
        bdcData: [
          done: 10
          standard: 8
        ,
          done: 15.89
          standard: 16
        ,
          done: null
          standard: 24
        ,
          done: null
          standard: 32
        ]
      @dynamicFields.ready(sprint)
      .then (builtDict) ->
        expect(builtDict['{done}']).toBe '15.9'
        expect(builtDict['{gap}']).toBe '0.1'
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
