require '../states/template/style.less'

angular.module 'Scrumble.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.daily-report',
    url: '/daily-report'
    template: require('../states/template/view.html')
    controller: 'DailyReportCtrl'
    resolve:
      dailyReport: (DailyReport) ->
        DailyReport.get()
        .catch (error) ->
          if error.status is 404
            DailyReport.new().$save()
