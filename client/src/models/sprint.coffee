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

  handleDates = (sprint) ->
    if sprint?.bdcData?
      # the date is saved as a string so we've to convert it
      for day in sprint.bdcData
        day.date = moment(day.date).toDate()

      # check start/end date consistency
      if _.isArray(sprint?.dates?.days) and sprint?.dates?.days.length > 0
        [first, ..., last] = sprint.dates.days
        sprint.dates.start = moment(first.date).toDate()
        sprint.dates.end = moment(last.date).toDate()
      else
        if sprint?
          sprint.dates.start = null
          sprint.dates.end = null
    sprint

  get: (parameters, success, error) ->
    resource.get(parameters, success, error).$promise
    .then handleDates
  query: resource.query
  getActiveSprint: resource.getActiveSprint
  activate: (sprintId) ->
    return unless sprintId?
    $http.put("#{endpoint}/#{sprintId}/activate").$promise
    @getLastSpeeds = (projectId) ->
  save: (sprint) ->
    return sprint.$update() if sprint.id?
    return sprint.$save()
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

#
#     @getByProjectId = (projectId) ->
#       @query(
#         where:
#           project:
#             __type: "Pointer"
#             className: "Project"
#             objectId: projectId
#       ).then (sprints) ->
#         _.sortByOrder sprints, 'number', false
#       .then (sprints) ->
#         for sprint in sprints
#           handleDates sprint
#         sprints
#
