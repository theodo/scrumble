angular.module 'Scrumble.sprint'
.factory 'BDCDataProvider', ->
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

  initializeBDC: initializeBDC
