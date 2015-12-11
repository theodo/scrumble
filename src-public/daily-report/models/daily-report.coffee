angular.module 'NotSoShitty.daily-report'
.factory 'DailyReport', (Parse) ->
  class DailyReport extends Parse.Model
    @configure "DailyReport", "project", "message"

    @getByProject = (project) ->
      @query(
        equalTo:
          project: project
      ).then (response) ->
        if response.length > 0
          return response[0]
        else
          return null
