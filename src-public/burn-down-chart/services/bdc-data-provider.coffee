angular.module 'NotSoShitty.bdc'
.factory 'BDCDataProvider', ->
  getCardPoints = (card) ->
    return unless card.name
    match = card.name.match /\(([-+]?[0-9]*\.?[0-9]+)\)/
    value = 0
    if match
      for matchVal in match
        value = parseFloat(matchVal, 10) unless isNaN(parseFloat(matchVal, 10))
    value

  getDonePoints = (doneCards) ->
    _.sum doneCards, getCardPoints

  hideFuture = (value, day, today) ->
    return if isNaN value
    return if moment(today).isBefore moment(day.date).add(1, 'days')
    value

  generateData = (cards, days, resources, dayPlusOne, dailyHour) ->
    return unless cards and days and resources
    data = []
    ideal = resources.speed * resources.totalManDays
    doneToday = 0
    diff = 0
    today = Date().toString()
    if dayPlusOne
      today = moment(today).add(1, 'days').toString()
    data.push {
      day: 'Start'
      standard: ideal
      done: 0
      left: ideal
      diff: 0
    }
    previousDay = undefined
    for day, i in days
      manDays = _.reduce resources.matrix[i], (s, n) -> s + n
      donePoints = getDoneBetweenDays cards, days[i - 1], day, (i >= days.length - 1), dailyHour
      ideal = ideal - resources.speed * manDays
      doneToday += donePoints
      diff = ideal - (resources.totalPoints - doneToday)

      data.push {
        day: day.label
        done: donePoints
        manDays: manDays
        standard: ideal
        left: hideFuture resources.totalPoints - doneToday, day, today
        diff: hideFuture diff, day, today
      }
      previousDay = day

    data

  generateData: generateData
  getCardPoints: getCardPoints
