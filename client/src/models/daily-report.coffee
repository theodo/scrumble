angular.module 'Scrumble.models'
.service 'DailyReport', ($resource, $http, API_URL) ->
  endpoint = "#{API_URL}/DailyReports"
  DailyReport = $resource(
    "#{endpoint}/:dailyReportId:action",
    {dailyReportId: '@id'},
    update:
      method: 'PUT'
    getProjectReport:
      method: 'GET'
      params:
        action: 'current'
  )

  get: (parameters, success, error) ->
    if parameters?.projectId?
      DailyReport.get(parameters, success, error).$promise
    else
      DailyReport.getProjectReport().$promise
  query: DailyReport.query
  save: (dailyReport) ->
    return dailyReport.$update() if dailyReport.id?
    return dailyReport.$save()
  new: () ->
    new DailyReport()
