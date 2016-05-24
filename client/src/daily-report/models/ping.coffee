angular.module 'Scrumble.daily-report'
.factory 'DailyReportPing', (Parse) ->
  class DailyReportPing extends Parse.Model
    @configure "DailyReportPing", "name"
