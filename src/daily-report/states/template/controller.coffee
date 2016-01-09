angular.module 'NotSoShitty.daily-report'
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
) ->
  $scope.project = project
  $scope.sprint = sprint

  reportBuilder.init()

  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top right')
    .content('Saved!')

  $scope.dailyReport = dailyReport
  $scope.todaysGoals = []
  $scope.previousGoals = dailyReport.metadata?.previousGoals
  $scope.problems = "## Problems\n"

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
            _.filter($scope.previousGoals, 'display'),
            $scope.todaysGoals,
            $scope.problems,
            false
          )
        rawMessage: ->
          $scope.dailyReport.message
        dailyReport: -> $scope.dailyReport
        todaysGoals: -> $scope.todaysGoals
        previousGoals: ->
          _.filter $scope.previousGoals, 'display'
        problems: -> $scope.problems
        sprint: ->
          sprint
