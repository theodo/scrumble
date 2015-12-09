angular.module 'NotSoShitty.bdc'
.controller 'NewSprintCtrl', (
  $scope
  $timeout
  $state
  TrelloClient
  project
  sprintService
  Sprint
  Project
) ->
  Project.find("u8o4xBMREA").then (o) ->
    console.log o
  $scope.project = project
  console.log project
  $scope.sprint = new Sprint
    project: project
    number: null
    doneColumn: null
    dates:
      start: null
      end: null
      days: []
    resources:
      matrix: []
      speed: null
      totalPoints: null
    isActive: false

  $scope.sprint.dates ?=
    start: null
    end: null
    days: []

  TrelloClient.get("/boards/#{project.boardId}/lists")
  .then (response) ->
    $scope.boardLists = response.data

  $scope.devTeam = project.team?.dev

  promise = null
  $scope.save = ->
    $scope.activable = isActivable()

    # wait 2s before saving
    if promise?
      $timeout.cancel promise
    promise = $timeout ->
      $scope.sprint.save()
    , 1000

  $scope.activable = false
  isActivable = ->
    s = $scope.sprint
    if s.number? and s.doneColumn? and s.dates.start? and s.dates.end? and s.dates.days.length > 0 and s.resources.matrix.length > 0 and s.resources.totalPoints? and s.resources.speed?
      true
    else
      false

  $scope.activate = ->
    if isActivable()
      $scope.sprint.isActive = true
      $scope.sprint.save().then ->
        $state.go 'current-sprint'

  $scope.$watch 'sprint.dates.end', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal?
    $scope.sprint.dates.days = sprintService.generateDayList $scope.sprint.dates.start, $scope.sprint.dates.end
    $scope.save()

  $scope.$watch 'sprint.dates.days', (newVal, oldVal) ->
    return if newVal is oldVal
    $scope.sprint.resources ?= {}
    $scope.sprint.resources.matrix = sprintService.generateResources $scope.sprint.dates?.days, $scope.devTeam
    $scope.save()

  $scope.$watch 'sprint.resources.matrix', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal
    $scope.sprint.resources.totalManDays = sprintService.getTotalManDays newVal
    $scope.save()

  $scope.$watch 'sprint.resources.totalManDays', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal and newVal > 0
    $scope.sprint.resources.speed = sprintService.calculateSpeed $scope.sprint.resources.totalPoints, newVal
    $scope.save()

  $scope.$watch 'sprint.resources.totalPoints', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal? and newVal > 0
    $scope.sprint.resources.speed = sprintService.calculateSpeed newVal, $scope.sprint.resources.totalManDays
    $scope.save()

  $scope.$watch 'sprint.resources.speed', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal? and newVal > 0
    $scope.sprint.resources.totalPoints = sprintService.calculateTotalPoints $scope.sprint.resources.totalManDays, newVal
    $scope.save()
