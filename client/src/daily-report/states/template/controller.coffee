angular.module 'Scrumble.daily-report'
.controller 'DailyReportCtrl', (
  $scope
  $mdToast
  $mdDialog
  $mdMedia
  $document
  reportBuilder
  DailyReport
  dailyReport
  dailyCache
) ->
  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top left')
    .content('Saved!')
    .parent($document[0].querySelector('main'))

  # If the daily report is in cache, use it
  sections = dailyCache.get 'sections'
  if sections?
    dailyReport.sections = sections
    $scope.sections = dailyReport.sections
  else
    dailyReport.sections ?= {}
    $scope.sections = dailyReport.sections
    dailyCache.put 'sections', $scope.sections

  $scope.save = (ev) ->
    DailyReport.save(dailyReport).then ->
      $mdToast.show saveFeedback

  $scope.preview = (ev) ->
    $mdDialog.show
      controller: 'PreviewCtrl'
      templateUrl: 'daily-report/states/preview/view.html'
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: $mdMedia 'sm'
      resolve:
        message: ->
          reportBuilder.render(
            $scope.sections
            dailyReport
            d3.select('#bdcgraph')[0][0].firstChild
            $scope.project
            $scope.sprint
          )
        dailyReport: -> dailyReport
        todaysGoals: -> $scope.sections.todaysGoals
