angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', (
  $scope
  $state
  $mdDialog
  $mdMedia
  BDCDataProvider
  TrelloClient
  trelloUtils
  svgToPng
  sprint
  Sprint
) ->
  # tmp for migration
  unless sprint.info?
    sprint.info =
      bdcTitle: 'Burndown Chart'
  $state.go 'tab.new-sprint' unless sprint?

  if sprint.bdcData?
    # the date is saved as a string so we've to convert it
    for day in sprint.bdcData
      day.date = moment(day.date).toDate()
  else
    sprint.bdcData = BDCDataProvider.initializeBDC sprint.dates.days, sprint.resources
  $scope.info = sprint.info
  $scope.tableData = sprint.bdcData

  getCurrentDayIndex = (bdcData) ->
    for day, i in bdcData
      return i unless day.done?
  $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.save = ->
    svg = d3.select('#bdcgraph')[0][0].firstChild
    sprint.bdcBase64 = svgToPng.getPngBase64 svg
    sprint.save().then ->
      $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.fetchTrelloDonePoints = ->
    if sprint.doneColumn?
      trelloUtils.getColumnPoints sprint.doneColumn
      .then (points) ->
        $scope.tableData[$scope.currentDayIndex].done = points

  $scope.showConfirmNewSprint = (ev) ->
    confirm = $mdDialog.confirm()
      .title 'Start a new sprint'
      .textContent 'Starting a new sprint will end this one'
      .targetEvent ev
      .ok 'OK'
      .cancel 'Cancel'
    $mdDialog.show(confirm).then ->
      Sprint.close(sprint).then ->
        $state.go 'tab.new-sprint'

  $scope.openBDCMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev

  $scope.openEditTitle = (ev) ->
    useFullScreen = ($mdMedia 'sm' or $mdMedia 'xs')
    $mdDialog.show(
      controller: DialogController
      templateUrl: 'sprint/states/current-sprint/editBDCTitle.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: useFullScreen
      resolve:
        title: -> sprint.info?.bdcTitle
    ).then (title) ->
      sprint.info.bdcTitle = title
      sprint.save()

  DialogController = ($scope, $mdDialog, title) ->
    $scope.title = title
    $scope.hide = ->
      $mdDialog.hide()
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.save = ->
      $mdDialog.hide $scope.title
