describe 'dynamicFields', ->
  beforeEach module 'Scrumble.common'

  beforeEach inject (dynamicFields, $rootScope) ->
    @dynamicFields = dynamicFields
    @$rootScope = $rootScope

  describe 'sprint', ->
    it 'should be a function', ->
      expect(@dynamicFields.sprint).toEqual jasmine.any(Function)

  describe 'project', ->
    it 'should be a function', ->
      expect(@dynamicFields.project).toEqual jasmine.any(Function)

  describe 'getDictionary', ->
    it 'should return an object', ->
      expect(@dynamicFields.getAvailableFields()).toEqual jasmine.any(Array)

  describe 'render', ->
    it 'should replace sprint fields', (done) ->
      text = '{sprintNumber},{sprintGoal},{speed}'

      @dynamicFields.sprint
        number: 10
        goal: 'Eat more carrots'
        resources:
          speed: 1.6666667

      @dynamicFields.render text
      .then (result) ->
        expect(result).toBe '10,Eat more carrots,1.7'
        done()
      @$rootScope.$apply()

    it 'should replace several times', (done) ->
      text = '{sprintNumber},{sprintNumber}'
      @dynamicFields.sprint
        number: 10

      @dynamicFields.render text
      .then (result) ->
        expect(result).toBe '10,10'
        done()
      @$rootScope.$apply()

    it 'should replace {today#YYYY-MM-DD}', (done) ->
      text = 'On {today#YYYY-MM-DD} I will eat 10 carrots. Yes, on {today#YYYY-MM-DD}'
      expected = 'On ' + moment().format('YYYY-MM-DD') + ' I will eat 10 carrots. Yes, on ' + moment().format('YYYY-MM-DD')

      @dynamicFields.render text
      .then (result) ->
        expect(result).toBe expected
        done()
      @$rootScope.$apply()

    it 'should replace {yesterday#YYYY-MM-DD}', (done) ->
      text = 'On {yesterday#YYYY-MM-DD} I will eat 10 carrots. Yes, on {yesterday#YYYY-MM-DD}'
      expected = 'On ' + moment().subtract(1, 'days').format('YYYY-MM-DD') + ' I will eat 10 carrots. Yes, on ' + moment().subtract(1, 'days').format('YYYY-MM-DD')

      @dynamicFields.render text
      .then (result) ->
        expect(result).toBe expected
        done()
      @$rootScope.$apply()

    it 'should not raise error with undefined input', (done) ->
      text = undefined

      @dynamicFields.render text
      .then (result) ->
        expect(result).toBe ''
        done()
      @$rootScope.$apply()
