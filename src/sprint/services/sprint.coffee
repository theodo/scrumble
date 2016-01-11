angular.module 'NotSoShitty.sprint'
.service 'sprintUtils', ->
  generateDayList = (start, end) ->
    return unless start? and end?
    # check if start < end
    current = moment start
    endM = moment(end).add(1, 'days')
    return unless endM.isAfter current
    days = []
    while not current.isSame endM
      day = current.isoWeekday()
      if day isnt 6 and day isnt 7
        days.push {
          date: current.format()
        }
      current.add 1, 'days'
    days
  generateResources = (days, devTeam, previous={days: [], matrix: []}) ->
    return unless days? and devTeam?
    matrix = []
    for day in days
      index = _.findIndex previous.days, day
      if index > -1 and devTeam.length == previous.matrix[index].length
        matrix.push previous.matrix[index]
      else
        matrix.push (1 for member in devTeam)
    matrix
  getTotalManDays = (matrix = []) ->
    total = 0
    for line in matrix
      for cell in line
        total += cell
    total
  calculateTotalPoints = (totalManDays, speed) ->
    totalManDays * speed
  calculateSpeed = (totalPoints, totalManDays) ->
    return unless totalManDays > 0
    totalPoints / totalManDays
  generateBDC: (days, resources, previous = []) ->
    standard = 0
    bdc = []
    fetchDone = (date) ->
      dayFromPrevious = _.find previous, (elt) ->
        moment(elt.date).format() is moment(date).format()
      done = if dayFromPrevious? then dayFromPrevious.done else null

    for day, i in days
      date = moment(day.date).toDate()

      bdc.push {
        date: date
        standard: standard
        done: fetchDone(date)
      }
      standard += _.sum(resources.matrix[i]) * resources.speed

    # add last point for ceremony
    date = moment(day.date).add(1, 'days').toDate()
    bdc.push {
      date: date
      standard: standard
      done: fetchDone(date)
    }
    bdc
  computeSpeed: (sprint) ->
    return unless _.isArray sprint.bdcData
    [first, ..., last] = sprint.bdcData
    if _.isNumber last.done
      speed = last.done / sprint.resources.totalManDays
      speed.toFixed(1)
  isActivable: (s) ->
    if (
      s.number? and
      s.doneColumn? and
      s.dates?.start? and
      s.dates?.end? and
      s.dates?.days?.length > 0 and
      s.resources?.matrix?.length > 0 and
      s.resources?.totalPoints? and
      s.resources?.speed?
    )
      true
    else
      false
  ensureDataConsistency: (source, sprint, devTeam) ->
    return if source is 'number' or source is 'done'
    # regenerate date list if start or end values changed
    if source is 'date'
      previous =
        days: sprint.dates.days
        matrix: sprint.resources.matrix
      sprint.dates.days = generateDayList sprint.dates.start, sprint.dates.end
      sprint.resources.matrix = generateResources sprint.dates.days, devTeam, previous

    if source is 'team'
      previous =
        days: sprint.dates.days
        matrix: sprint.resources.matrix
      sprint.resources.matrix = generateResources sprint.dates.days, devTeam, previous

    if source is 'date' or source is 'resource' or source is 'speed'
      sprint.resources.totalManDays = getTotalManDays sprint.resources.matrix
      sprint.resources.totalPoints = calculateTotalPoints sprint.resources.totalManDays, sprint.resources.speed

    if source is 'total'
      sprint.resources.speed = calculateSpeed sprint.resources.totalPoints, sprint.resources.totalManDays
