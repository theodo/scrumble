angular.module 'NotSoShitty.bdc'
.controller 'NewSprintCtrl', (
  $scope
  $timeout
  TrelloClient
  SettingsStorage
  sprintService
  boardId
  Sprint
) ->
  $scope.sprint = new Sprint(boardId: boardId)
  # Sprint.find('vEun76jEao').then (sprint) ->
  #   $scope.sprint = sprint

  TrelloClient.get("/boards/#{boardId}/lists")
  .then (response) ->
    $scope.boardLists = response.data

  SettingsStorage.get(boardId)
  .then (settings) ->
    $scope.devTeam = settings.data.team?.dev

  promise = null
  $scope.save = ->
    # wait 2s before saving
    if promise?
      $timeout.cancel promise
    promise = $timeout ->
      $scope.sprint.save()
    , 2000

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
    return unless newVal and newVal > 0
    $scope.sprint.resources.speed = sprintService.calculateSpeed newVal, $scope.sprint.resources.totalManDays
    $scope.save()

  $scope.$watch 'sprint.resources.speed', (newVal, oldVal) ->
    return if newVal is oldVal
    return unless newVal and newVal > 0
    $scope.sprint.resources.totalPoints = sprintService.calculateTotalPoints $scope.sprint.resources.totalManDays, newVal
    $scope.save()
