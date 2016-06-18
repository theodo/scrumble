angular.module 'Scrumble.models'
.service 'DailyReportPing', ($resource, $q, $http, API_URL) ->
  endpoint = "#{API_URL}/DailyReportPings"
  DailyReportPing = $resource(
    "#{endpoint}/:pingId",
    {pingId: '@id'},
    update:
      method: 'PUT'
  )

  new: ->
    new DailyReportPing()
  get: (parameters, success, error) ->
    DailyReportPing.get(parameters, success, error).$promise
  find: (parameters, success, error) ->
    DailyReportPing.query(parameters, success, error).$promise
