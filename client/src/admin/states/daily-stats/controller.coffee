angular.module 'Scrumble.admin'
.controller 'StatsCtrl', ($scope, DailyReportPing) ->
  pings = []

  DailyReportPing.find().then (_pings_) ->
    pings = _pings_
    $scope.pingsLength = pings.length

    pingsPerHour = _(pings)
    .filter (ping) ->
      moment().diff(ping.createdAt, 'days') < 15
    .countBy (ping) -> moment(ping.createdAt).hours()
    .map (value, key) ->
      hour: parseInt key
      count: value
    .orderBy 'hour'
    .value()

    pingsPerDay = _(pings)
    .countBy (ping) -> moment(ping.createdAt).format('YYYY-MM-DD')
    .map (value, key) ->
      date: key
      count: value
    .value()

    chart = c3.generate
      bindto: '#ping-per-day'
      data:
        json: pingsPerDay
        keys:
          x: 'date'
          value: ['count']
        type: 'bar'
      axis:
        x:
          type: 'timeseries'
          tick:
            format: '%Y-%m-%d'

    chart = c3.generate
      bindto: '#ping-hour'
      data:
        json: pingsPerHour
        keys:
          x: 'hour'
          value: ['count']
        type: 'bar'
      axis:
        x:
          type: 'category'

  $scope.alertTeams = []
  # return the pings that sent a daily the day before the date but not at the date
  $scope.computeDiff = (date) ->
    datePings = _.filter pings, (ping) ->
      moment(date).isSame(ping.createdAt, 'day')

    previousDayPings = _.filter pings, (ping) ->
      moment(date).subtract(1, 'day').isSame(ping.createdAt, 'day')

    $scope.alertDailies = _.differenceBy(previousDayPings, datePings, 'name')
