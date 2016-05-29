angular.module 'Scrumble.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/template/view.html'
    controller: 'DailyReportCtrl'
    resolve:
      dailyReport: (DailyReport) ->
        DailyReport.get()
        .catch (error) ->
          if error.status is 404
            DailyReport.new().$save()
