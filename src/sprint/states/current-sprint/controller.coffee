angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', (
  $scope
  $state
  $mdDialog
  $mdMedia
  BDCDataProvider
  TrelloClient
  trelloUtils
  dynamicFields
  svgToPng
  sprint
  project
  Sprint
) ->
  $state.go 'tab.new-sprint' unless sprint?

  dynamicFields.project project
  dynamicFields.sprint sprint

  if sprint.bdcData?
    # the date is saved as a string so we've to convert it
    for day in sprint.bdcData
      day.date = moment(day.date).toDate()
  else
    sprint.bdcData = BDCDataProvider.initializeBDC sprint.dates.days, sprint.resources
  $scope.bdcTitle = dynamicFields.render project.settings?.bdcTitle
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
        title: -> project.settings?.bdcTitle
        availableFields: -> dynamicFields.getAvailableFields()
    ).then (title) ->
      project.settings ?= {}
      project.settings.bdcTitle = title
      project.save().then (project) ->
        $scope.bdcTitle = dynamicFields.render project.settings?.bdcTitle

  DialogController = ($scope, $mdDialog, title, availableFields) ->
    $scope.title = title
    $scope.availableFields = availableFields
    $scope.hide = ->
      $mdDialog.hide()
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.save = ->
      $mdDialog.hide $scope.title
