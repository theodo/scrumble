angular.module 'NotSoShitty.bdc'
.controller 'EditSprintCtrl', (
  $scope
  $timeout
  $state
  TrelloClient
  project
  sprintUtils
  sprint
  Project
) ->
  $scope.project = project

  if sprint.bdcData?
    # the date is saved as a string so we've to convert it
    for day in sprint.bdcData
      day.date = moment(day.date).toDate()
    sprint.dates.start = moment(sprint.dates.start).toDate()
    sprint.dates.end = moment(sprint.dates.end).toDate()

  $scope.sprint = sprint


  TrelloClient.get("/boards/#{project.boardId}/lists")
  .then (response) ->
    $scope.boardLists = response.data

  $scope.devTeam = project.team?.dev

  promise = null
  $scope.saveLabel = if $state.is 'tab.new-sprint' then 'Start the sprint' else 'Save'
  $scope.title = if $state.is 'tab.new-sprint' then 'NEW SPRINT' else 'EDIT SPRINT'

  $scope.save = ->
    if isActivable()
      $scope.sprint.save()

  $scope.activable = false
  isActivable = ->
    s = $scope.sprint
    if (
      s.number? and
      s.doneColumn? and
      s.dates.start? and
      s.dates.end? and
      s.dates.days.length > 0 and
      s.resources.matrix.length > 0 and
      s.resources.totalPoints? and
      s.resources.speed?
    )
      true
    else
      false

  $scope.activate = ->
    if isActivable()
      $scope.sprint.isActive = true
      $scope.sprint.save().then ->
        $state.go 'tab.current-sprint'

  $scope.$watch 'sprint.dates.end', (newVal, oldVal) ->
    $scope.activable = isActivable()
    return if newVal is oldVal
    return unless newVal?
    $scope.sprint.dates.days = sprintUtils.generateDayList $scope.sprint.dates.start, $scope.sprint.dates.end

  $scope.$watch 'sprint.dates.days', (newVal, oldVal) ->
    $scope.activable = isActivable()
    return if newVal is oldVal
    $scope.sprint.resources ?= {}
    $scope.sprint.resources.matrix = sprintUtils.generateResources $scope.sprint.dates?.days, $scope.devTeam

  $scope.$watch 'sprint.resources.matrix', (newVal, oldVal) ->
    $scope.activable = isActivable()
    return if newVal is oldVal
    return unless newVal
    previousSpeed = $scope.sprint.resources.speed
    $scope.sprint.resources.totalManDays = sprintUtils.getTotalManDays newVal
    $scope.sprint.resources.totalPoints = sprintUtils.calculateTotalPoints $scope.sprint.resources.totalManDays, previousSpeed

  $scope.$watch 'sprint.resources.totalManDays', (newVal, oldVal) ->
    $scope.activable = isActivable()
    return if newVal is oldVal
    return unless newVal and newVal > 0
    $scope.sprint.resources.speed = sprintUtils.calculateSpeed $scope.sprint.resources.totalPoints, newVal

  $scope.$watch 'sprint.resources.totalPoints', (newVal, oldVal) ->
    $scope.activable = isActivable()
    return if newVal is oldVal
    return unless newVal? and newVal > 0
    $scope.sprint.resources.speed = sprintUtils.calculateSpeed newVal, $scope.sprint.resources.totalManDays

  $scope.$watch 'sprint.resources.speed', (newVal, oldVal) ->
    $scope.activable = isActivable()
    return if newVal is oldVal
    return unless newVal? and newVal > 0
    $scope.sprint.resources.totalPoints = sprintUtils.calculateTotalPoints $scope.sprint.resources.totalManDays, newVal
