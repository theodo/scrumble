describe 'dynamicFields', ->
  beforeEach module 'NotSoShitty.common'

  beforeEach inject (dynamicFields) ->
    @dynamicFields = dynamicFields

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
    it 'should replace sprint fields', ->
      text = '{sprintNumber},{sprintGoal},{speed}'

      @dynamicFields.sprint
        number: 10
        goal: 'Eat more carrots'
        resources:
          speed: 1.6666667

      result = @dynamicFields.render text
      expect(result).toBe '10,Eat more carrots,1.7'

    it 'should replace several times', ->
      text = '{sprintNumber},{sprintNumber}'
      @dynamicFields.sprint
        number: 10

      result = @dynamicFields.render text
      expect(result).toBe '10,10'

    it 'should replace {today#YYYY-MM-DD}', ->
      text = 'On {today#YYYY-MM-DD} I will eat 10 carrots. Yes, on {today#YYYY-MM-DD}'
      expected = 'On ' + moment().format('YYYY-MM-DD') + ' I will eat 10 carrots. Yes, on ' + moment().format('YYYY-MM-DD')

      result = @dynamicFields.render text
      expect(result).toBe expected

    it 'should replace {yesterday#YYYY-MM-DD}', ->
      text = 'On {yesterday#YYYY-MM-DD} I will eat 10 carrots. Yes, on {yesterday#YYYY-MM-DD}'
      expected = 'On ' + moment().subtract(1, 'days').format('YYYY-MM-DD') + ' I will eat 10 carrots. Yes, on ' + moment().subtract(1, 'days').format('YYYY-MM-DD')

      result = @dynamicFields.render text
      expect(result).toBe expected

    it 'should not raise error with undefined input', ->
      text = undefined

      result = @dynamicFields.render text
      expect(result).toBe ''
