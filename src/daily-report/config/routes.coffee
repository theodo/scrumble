angular.module 'NotSoShitty.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/template/view.html'
    controller: 'DailyReportCtrl'
    resolve:
      dailyReport: (NotSoShittyUser, DailyReport, Project) ->
        NotSoShittyUser.getCurrentUser().then (user) ->
          DailyReport.getByProject(user.project).then (report) ->
            return report if report?
            report = new DailyReport
              project: new Project user.project
              message:
                subject: '[MyProject] Sprint #{sprintNumber} - Daily Mail {today#YYYY-MM-DD}'
                body: 'Hello Batman,\n\n' +
                  'here is the daily mail:\n\n' +
                  '- Done: {done} / {total} points\n' +
                  '- To validate: {toValidate} points\n' +
                  '- Blocked: {blocked} points\n' +
                  '- {behind/ahead}: {gap} points {color=smart}\n\n' +
                  '{bdc}\n\n' +
                  'Yesterday\'s goals:\n' +
                  '- Eat carrots {color=green}\n\n' +
                  'Today\'s goals\n' +
                  '- Eat more carrots\n\n' +
                  'Regards!'
                behindLabel: 'Behind'
                aheadLabel: 'Ahead'
            report.save()
      sprint: (NotSoShittyUser, Sprint) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          Sprint.getActiveSprint user.project
        .catch (err) ->
          console.log err
          return null
      project: (NotSoShittyUser) ->
        NotSoShittyUser.getCurrentUser().then (user) ->
          user.project
