angular.module 'NotSoShitty.bdc'
.controller 'BurnDownChartCtrl', (
  $scope
  BDCDataProvider
  settings
  doneCards
) ->
  if settings.data.bdc?
    # the date is saved as a string so we've to convert it
    for day in settings.data.bdc
      day.date = moment(day.date).toDate()
  else
    settings.data.bdc = BDCDataProvider.initializeBDC settings.data.dates.days, settings.data.resources

  $scope.tableData = settings.data.bdc

  getCurrentDayIndex = (bdcData) ->
    for day, i in bdcData
      return i unless day.done?
  $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.save = ->
    settings.save().then ->
      $scope.currentDayIndex = getCurrentDayIndex $scope.tableData

  $scope.tableData[$scope.currentDayIndex].done = BDCDataProvider.getDonePoints doneCards
  return
