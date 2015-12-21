describe 'sprintUtils', ->
  beforeEach module 'NotSoShitty.bdc'

  beforeEach inject (sprintUtils) ->
    @sprintUtils = sprintUtils

  describe 'generateDayList', ->
    it 'should be a function', ->
      expect(@sprintUtils.generateDayList).toEqual jasmine.any(Function)

    it 'should return undefined if start or end is not defined', ->
      result = @sprintUtils.generateDayList null, '2015-12-20'
      expect(result).toBe undefined

      result = @sprintUtils.generateDayList '2015-12-20', null
      expect(result).toBe undefined

    it 'should return undefined if start is later than end', ->
      result = @sprintUtils.generateDayList null, '2015-12-20'
      expect(result).toBe undefined

      result = @sprintUtils.generateDayList '2015-12-20', '2015-12-19'
      expect(result).toBe undefined

    it 'should not return Satursdays and Sundays', ->
      result = @sprintUtils.generateDayList '2015-12-16', '2015-12-23'
      dates = (moment(day.date).format('YYYY-MM-DD') for day in result)

      expect(dates).toContain '2015-12-16'
      expect(dates).toContain '2015-12-17'
      expect(dates).toContain '2015-12-18'
      expect(dates).not.toContain '2015-12-19'
      expect(dates).not.toContain '2015-12-20'
      expect(dates).toContain '2015-12-21'
      expect(dates).toContain '2015-12-22'
      expect(dates).toContain '2015-12-23'

  describe 'generateResources', ->
    it 'should be a function', ->
      expect(@sprintUtils.generateResources).toEqual jasmine.any(Function)

    it 'should return undefined if an input is undefined', ->
      result = @sprintUtils.generateResources null, []
      expect(result).toBe undefined

    it 'should return a 2D array of size [days][teamLength]', ->
      result = @sprintUtils.generateResources [null, null, null], [null, null]
      expect(result.length).toBe 3
      expect(result[0].length).toBe 2

  describe 'getTotalManDays', ->
    it 'should be a function', ->
      expect(@sprintUtils.getTotalManDays).toEqual jasmine.any(Function)

    it 'should return 0 if an input is undefined', ->
      result = @sprintUtils.getTotalManDays null
      expect(result).toBe 0

    it 'should return the expected value', ->
      result = @sprintUtils.getTotalManDays []
      expect(result).toBe 0

      result = @sprintUtils.getTotalManDays [[1,1,1], [1,1,1]]
      expect(result).toBe 6

      result = @sprintUtils.getTotalManDays [[1,1,0], [0.5,1,1]]
      expect(result).toBe 4.5

  describe 'calculateTotalPoints', ->
    it 'should be a function', ->
      expect(@sprintUtils.calculateTotalPoints).toEqual jasmine.any(Function)

    it 'should return total * speed', ->
      result = @sprintUtils.calculateTotalPoints 3, 2.5
      expect(result).toBe 3*2.5

  describe 'calculateSpeed', ->
    it 'should be a function', ->
      expect(@sprintUtils.calculateSpeed).toEqual jasmine.any(Function)

    it 'should return totalPoints * totalManDay', ->
      result = @sprintUtils.calculateSpeed 62, 12
      expect(result).toBe 62/12

    it 'should return undefined if totalManDay is inconsistent', ->
      result = @sprintUtils.calculateSpeed 62, -2
      expect(result).toBe undefined

      result = @sprintUtils.calculateSpeed 62, null
      expect(result).toBe undefined

      # generateBDC: (days, resources, previous = []) ->
      #   standard = 0
      #   bdc = []
      #   fetchDone = (date) ->
      #     dayFromPrevious = _.find previous, (elt) -> elt.date = date
      #     done = if dayFromPrevious? then dayFromPrevious.done else null
      #
      #   for day, i in days
      #     date = moment(day.date).toDate()
      #
      #     bdc.push {
      #       date: date
      #       standard: standard
      #       done: fetchDone(date)
      #     }
      #     standard += _.sum(resources.matrix[i]) * resources.speed
      #
      #   # add last point for ceremony
      #   date = moment(day.date).add(1, 'days').toDate()
      #   bdc.push {
      #     date: date
      #     standard: standard
      #     done: fetchDone(date)
      #   }
      #
      #   bdc

  describe 'generateBDC', ->
    days = [
      date: '2015-12-16'
    ,
      date: '2015-12-17'
    ,
      date: '2015-12-18'
    ]

    resources =
      speed: 2
      matrix: [[1,1,1], [1,1,0], [1,0.5,1]]
    it 'should be a function', ->
      expect(@sprintUtils.generateBDC).toEqual jasmine.any(Function)

    it 'should return an array of length days + 1', ->
      result = @sprintUtils.generateBDC days, resources
      expect(result.length).toBe days.length + 1

    it 'should return an array of object of good shape', ->
      expectedShape =
        date: jasmine.any(Date)
        standard: jasmine.any(Number)
        done: null
      result = @sprintUtils.generateBDC days, resources
      expect(result[0]).toEqual expectedShape

    it 'should return expected standard values', ->
      result = @sprintUtils.generateBDC days, resources
      expect(result[0].standard).toBe 0
      expect(result[1].standard).toBe 6
      expect(result[2].standard).toBe 10
      expect(result[3].standard).toBe 15

    it 'should not erase already set done values', ->
      previous = [
        date: '2015-12-16'
        done: 3
      ]
      result = @sprintUtils.generateBDC days, resources, previous
      expect(result[0].done).toBe 3
      expect(result[1].done).toBe null
      expect(result[2].done).toBe null
      expect(result[3].done).toBe null
