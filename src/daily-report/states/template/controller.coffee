angular.module 'Scrumble.daily-report'
.controller 'DailyReportCtrl', (
  $scope
  $mdToast
  $mdDialog
  $mdMedia
  mailer
  reportBuilder
  dailyReport
  sprint
  project
  dynamicFields
  dailyReportCache
) ->
  $scope.project = project
  $scope.sprint = sprint

  reportBuilder.init()

  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top right')
    .content('Saved!')

  $scope.dailyReport = dailyReport
  $scope.dailyReportCache = dailyReportCache
  $scope.dailyReportCache.todaysGoals ?= []
  $scope.dailyReportCache.previousGoals ?= dailyReport.metadata?.previousGoals
  $scope.dailyReportCache.sections ?=
    problems: "## Problems\n"
    intro: ""

  $scope.save = ->
    $scope.dailyReport.save().then ->
      $mdToast.show saveFeedback

  $scope.openMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev

  $scope.openDynamicFields = (ev) ->
    useFullScreen = ($mdMedia 'sm' or $mdMedia 'xs')
    $mdDialog.show
      controller: 'DynamicFieldsModalCtrl'
      templateUrl: 'daily-report/states/template/dynamic-fields.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: useFullScreen
      resolve:
        dailyReport: -> dailyReport
        availableFields: ->
          _.union(
            dynamicFields.getAvailableFields()
            reportBuilder.getAvailableFields()
          )

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
            $scope.dailyReport.message,
            _.filter($scope.dailyReportCache.previousGoals, 'display'),
            $scope.dailyReportCache.todaysGoals,
            $scope.dailyReportCache.sections,
            d3.select('#bdcgraph')[0][0].firstChild
            false
          )
        rawMessage: ->
          $scope.dailyReport.message
        dailyReport: -> $scope.dailyReport
        todaysGoals: -> $scope.dailyReportCache.todaysGoals
        previousGoals: ->
          _.filter $scope.dailyReportCache.previousGoals, 'display'
        sections: -> $scope.dailyReportCache.sections
        sprint: ->
          sprint
