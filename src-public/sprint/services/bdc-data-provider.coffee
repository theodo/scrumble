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

  initializeBDC = (days, resources) ->
    standard = 0
    bdc = []
    for day, i in days
      bdc.push {
        date: moment(day.date).toDate()
        standard: standard
        done: null
      }
      standard += _.sum(resources.matrix[i]) * resources.speed
    bdc.push {
      date: moment(day.date).add(1, 'days').toDate()
      standard: standard
      done: null
    }
    bdc

  getCardPoints: getCardPoints
  initializeBDC: initializeBDC
  getDonePoints: getDonePoints
