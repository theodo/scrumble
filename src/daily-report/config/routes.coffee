angular.module 'Scrumble.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.edit-template',
    url: '/daily-report/edit'
    templateUrl: 'daily-report/states/edit-template/view.html'
    controller: 'EditTemplateCtrl'
    resolve:
      dailyReport: (ScrumbleUser, DailyReport, Project) ->
        ScrumbleUser.getCurrentUser().then (user) ->
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
  .state 'tab.daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/template/view.html'
    controller: 'DailyReportCtrl'
    resolve:
      dailyReport: (ScrumbleUser, DailyReport, Project) ->
        ScrumbleUser.getCurrentUser().then (user) ->
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
