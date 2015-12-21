angular.module 'NotSoShitty.bdc'
.service 'sprintUtils', ->
  generateDayList: (start, end) ->
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
  generateResources: (days, devTeam) ->
    return unless days? and devTeam?
    matrix = []
    for day in days
      line = []
      for member in devTeam
        line.push 1
      matrix.push line
    matrix
  getTotalManDays: (matrix = []) ->
    total = 0
    for line in matrix
      for cell in line
        total += cell
    total
  calculateTotalPoints: (totalManDays, speed) ->
    totalManDays * speed
  calculateSpeed: (totalPoints, totalManDays) ->
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
