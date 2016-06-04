angular.module 'Scrumble.models'
.service 'Sprint', ($resource, $http, API_URL) ->
  endpoint = "#{API_URL}/Sprints"
  resource = $resource(
    "#{endpoint}/:sprintId:action",
    {sprintId: '@id'},
    update:
      method: 'PUT'
    getActiveSprint:
      method: 'GET'
      params:
        action: 'active'
  )

  get: (parameters, success, error) ->
    resource.get(parameters, success, error).$promise
  query: (parameters, success, error) ->
    resource.query(parameters, success, error).$promise
  getActiveSprint: ->
    resource.getActiveSprint().$promise
  activate: (sprintId) ->
    return unless sprintId?
    $http.put("#{endpoint}/#{sprintId}/activate")
  save: (sprint) ->
    return sprint.$update() if sprint.id?
    return sprint.$save()
  delete: (sprintId) ->
    $http.delete("#{endpoint}/#{sprintId}")

  new: (projectId) ->
    new resource
      projectId: projectId
      info:
        bdcTitle: 'Burndown Chart'
      number: null
      goal: null
      doneColumn: null
      dates:
        start: null
        end: null
        days: []
      resources:
        matrix: []
        speed: null
        totalPoints: null
      isActive: false
