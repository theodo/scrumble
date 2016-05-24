angular.module 'Scrumble.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/template/view.html'
    controller: 'DailyReportCtrl'
    resolve:
      dailyReport: (ScrumbleUser, DailyReport, project) ->
        DailyReport.getByProject(project).then (report) ->
          return report if report?
          report = new DailyReport
            project: project
          report.save()
