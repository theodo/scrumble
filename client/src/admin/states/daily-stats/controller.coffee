angular.module 'Scrumble.admin'
.controller 'StatsCtrl', ($scope, DailyReportPing, Organization) ->
  pings = []


  DailyReportPing.find().then (_pings_) ->
    pings = _pings_
    $scope.pingsLength = pings.length

    $scope.days = (moment().add(i, 'days').format('YYYY-MM-DD') for i in [-15... 0])
    Organization.query(
      filter:
        include:
          projects: 'dailyReport'
    ).then (organizations) ->
      projectOrganizationMapping = {}
      for organization in organizations
        for project in organization.projects
          if project.dailyReport?.sections?.subject?
            projectOrganizationMapping[project.dailyReport.sections.subject] =
              organization: organization.name
              project: project.name

        groupedPings = _(pings).filter((ping) ->
          moment(ping.createdAt).isAfter(moment().add(-15, 'days'))
        ).groupBy('name').value()

      organizations = {}
      for key, projectPings of groupedPings
        groupedPings[key] = _.groupBy(projectPings, (ping) ->
          moment(ping.createdAt).format('YYYY-MM-DD')
        )
        if projectOrganizationMapping[key]?
          organizations[projectOrganizationMapping[key].organization] ?= {}
          organizations[projectOrganizationMapping[key].organization][projectOrganizationMapping[key].project] = groupedPings[key]
        else
          organizations['None'] ?= {}
          organizations['None'][key] = groupedPings[key]
      $scope.organizations = organizations

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
