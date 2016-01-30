angular.module 'Scrumble.daily-report'
.controller 'DailyReportCtrl', (
  $scope
  $mdToast
  $mdDialog
  $mdMedia
  $mdBottomSheet
  mailer
  reportBuilder
  dailyReport
  sprint
  project
  dynamicFields
  dailyReportCache
) ->
  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top right')
    .content('Saved!')

  $scope.sections =
    subject: angular.copy dailyReport.sections?.subject
    intro: angular.copy dailyReport.sections?.intro
    progress: angular.copy dailyReport.sections?.progress
    previousGoalsIntro: angular.copy dailyReport.sections?.previousGoalsIntro
    previousGoals: angular.copy dailyReport.sections?.previousGoals
    todaysGoalsIntro: angular.copy dailyReport.sections?.todaysGoalsIntro
    todaysGoals: null
    problems: angular.copy dailyReport.sections?.problems
    conclusion: angular.copy dailyReport.sections?.conclusion

  $scope.saveSection = (section, content) ->
    $mdToast.show saveFeedback
    dailyReport.sections ?= {}
    dailyReport.sections[section] = content
    dailyReport.save().then ->
      $mdToast.hide saveFeedback

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
            project
            sprint
          )
        dailyReport: -> dailyReport
        todaysGoals: -> $scope.sections.todaysGoals
