describe 'sprintUtils', ->
  beforeEach module 'Scrumble.sprint'

  beforeEach inject (sprintUtils) ->
    @sprintUtils = sprintUtils

  describe 'generateDayList', ->
    it 'should return undefined if start or end is not defined', ->
      sprint =
        dates:
          start: null
          end: '2015-12-20'
        resources: {}
      @sprintUtils.ensureDataConsistency 'date', sprint, []
      expect(sprint.dates.days).toBe undefined

      sprint =
        dates:
          start: '2015-12-20'
          end: null
        resources: {}
      @sprintUtils.ensureDataConsistency 'date', sprint, []
      expect(sprint.dates.days).toBe undefined

    it 'should return undefined if start is later than end', ->
      sprint =
        dates:
          start: '2015-12-20'
          end: '2015-12-19'
        resources: {}
      @sprintUtils.ensureDataConsistency 'date', sprint, []
      expect(sprint.dates.days).toBe undefined

    it 'should not return Satursdays and Sundays', ->
      sprint =
        dates:
          start: '2015-12-16'
          end: '2015-12-23'
        resources: {}
      @sprintUtils.ensureDataConsistency 'date', sprint, []
      dates = (moment(day.date).format('YYYY-MM-DD') for day in sprint.dates.days)

      expect(dates).toContain '2015-12-16'
      expect(dates).toContain '2015-12-17'
      expect(dates).toContain '2015-12-18'
      expect(dates).not.toContain '2015-12-19'
      expect(dates).not.toContain '2015-12-20'
      expect(dates).toContain '2015-12-21'
      expect(dates).toContain '2015-12-22'
      expect(dates).toContain '2015-12-23'

    it 'should handle different timezones', ->
      sprint =
        dates:
          start: '2016-05-09T23:00:00'
          end: '2016-05-12T22:00:00'
        resources: {}
      @sprintUtils.ensureDataConsistency 'date', sprint, []

  describe 'generateResources', ->
    it 'should return undefined if an input is undefined', ->
      sprint =
        dates:
          start: '2015-12-16'
          end: undefined
        resources: {}
      @sprintUtils.ensureDataConsistency 'date', sprint, []
      expect(sprint.resources.matrix).toBe undefined

    it 'should return a 2D array of size [days][teamLength]', ->
      sprint =
        dates:
          start: '2015-12-16'
          end: '2015-12-18'
        resources: {}
      @sprintUtils.ensureDataConsistency 'date', sprint, [null, null]
      matrix = sprint.resources.matrix
      expect(matrix.length).toBe 3
      expect(matrix[0].length).toBe 2

  describe 'getTotalManDays', ->
    it 'should return 0 if an input is undefined', ->
      sprint =
        resources:
          matrix: undefined
      @sprintUtils.ensureDataConsistency 'resource', sprint
      expect(sprint.resources.totalManDays).toBe 0

    it 'should return the expected value', ->
      sprint =
        resources:
          matrix: []
      @sprintUtils.ensureDataConsistency 'resource', sprint
      expect(sprint.resources.totalManDays).toBe 0

      sprint =
        resources:
          matrix: [[1,1,1], [1,1,1]]
      @sprintUtils.ensureDataConsistency 'resource', sprint
      expect(sprint.resources.totalManDays).toBe 6

      sprint =
        resources:
          matrix: [[1,1,0], [0.5,1,1]]
      @sprintUtils.ensureDataConsistency 'resource', sprint
      expect(sprint.resources.totalManDays).toBe 4.5

  describe 'calculateTotalPoints', ->

    it 'should return total * speed', ->
      sprint =
        resources:
          matrix: [[1,1,0], [0.5,1,1]]
          speed: 3
      @sprintUtils.ensureDataConsistency 'resource', sprint
      expect(sprint.resources.totalPoints).toBe 3*4.5

  describe 'calculateSpeed', ->

    it 'should return totalPoints * totalManDay', ->
      sprint =
        resources:
          totalPoints: 62
          totalManDays: 12
      @sprintUtils.ensureDataConsistency 'total', sprint
      expect(sprint.resources.speed).toBe 62/12

    it 'should return undefined if totalManDay is inconsistent', ->
      sprint =
        resources:
          totalPoints: 62
          totalManDays: -2
      @sprintUtils.ensureDataConsistency 'total', sprint
      expect(sprint.resources.speed).toBe undefined

      sprint =
        resources:
          totalPoints: 62
          totalManDays: undefined
      @sprintUtils.ensureDataConsistency 'total', sprint
      expect(sprint.resources.speed).toBe undefined

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
        done: 0
      expectedShape2 =
        date: jasmine.any(Date)
        standard: jasmine.any(Number)
        done: null
      result = @sprintUtils.generateBDC days, resources
      expect(result[0]).toEqual expectedShape
      expect(result[1]).toEqual expectedShape2

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
