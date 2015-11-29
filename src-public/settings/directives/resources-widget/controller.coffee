angular.module 'NotSoShitty.settings'
.controller 'ResourcesWidgetCtrl',
($scope, Computer) ->
  $scope.dates.start = moment($scope.dates.start).toDate()
  $scope.dates.end = moment($scope.dates.end).toDate()
  
  $scope.clearTeam = ->
    $scope.team.rest = []
    $scope.team.dev = []
  generateDayList = (start, end) ->
    return unless start and end
    # check if start < end
    current = moment start
    endM = moment(end).add(1, 'days')
    return unless endM.isAfter current
    days = []
    while not current.isSame endM
      day = current.isoWeekday()
      if day isnt 6 and day isnt 7
        days.push {
          label: current.format 'dddd'
          date: current.format()
        }
      current.add 1, 'days'
    days


  $scope.$watch 'dates.end', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal?
    $scope.dates.days = generateDayList $scope.dates.start, $scope.dates.end

  $scope.$watch 'dates.days', (newVal, oldVal) ->
    return if newVal is oldVal
    $scope.resources.matrix = Computer.generateResources $scope.dates?.days, $scope.team?.dev

  $scope.$watch 'team.dev', (newVal, oldVal) ->
    return if newVal is oldVal
    $scope.resources.matrix = Computer.generateResources $scope.dates?.days, $scope.team?.dev

  $scope.$watch 'resources.matrix', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal
    $scope.resources.totalManDays = Computer.getTotalManDays newVal

  $scope.$watch 'resources.totalManDays', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal and newVal > 0
    $scope.resources.speed = Computer.calculateSpeed $scope.resources.totalPoints, newVal

  $scope.$watch 'resources.totalPoints', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal and newVal > 0
    $scope.resources.speed = Computer.calculateSpeed newVal, $scope.resources.totalManDays

  $scope.$watch 'resources.speed', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal and newVal > 0
    $scope.resources.totalPoints = Computer.calculateTotalPoints $scope.resources.totalManDays, newVal
