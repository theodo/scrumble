angular.module 'NotSoShitty.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/view.html'
    controller: 'DailyReportCtrl'
    resolve:
      dailyReport: (NotSoShittyUser, DailyReport, Project) ->
        NotSoShittyUser.getCurrentUser().then (user) ->
          DailyReport.getByProject(user.project).then (report) ->
            return report if report?
            report = new DailyReport(project: new Project user.project)
            report.save()
    data:
      permissions:
        only: ['google-authenticated']
        redirectTo: 'tab.google-login'
