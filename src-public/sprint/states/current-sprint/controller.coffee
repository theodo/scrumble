angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', (
  $scope
  $state
  $mdDialog
  BDCDataProvider
  TrelloClient
  sprint
  Sprint
) ->
  $state.go 'tab.new-sprint' unless sprint?

  if sprint.bdcData?
    # the date is saved as a string so we've to convert it
    for day in sprint.bdcData
      day.date = moment(day.date).toDate()
  else
    sprint.bdcData = BDCDataProvider.initializeBDC sprint.dates.days, sprint.resources

  $scope.tableData = sprint.bdcData

  getCurrentDayIndex = (bdcData) ->
    for day, i in bdcData
      return i unless day.done?
  $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.save = ->
    sprint.save().then ->
      $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.fetchTrelloDonePoints = ->
    if sprint.doneColumn?
      TrelloClient.get '/lists/' + sprint.doneColumn + '/cards?fields=name'
      .then (response) ->
        doneCards = response.data
        $scope.tableData[$scope.currentDayIndex].done = BDCDataProvider.getDonePoints doneCards
      .catch (err) ->
        console.log err
        return null

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
