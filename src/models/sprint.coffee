angular.module 'Scrumble.models'
.service 'Sprint', ($resource, API_URL) ->
  $resource(
    "#{API_URL}/api/Sprints/:sprintId:action",
    {sprintId: '@id'},
    getActiveSprint:
      method: 'GET'
      params:
        action: 'active'
  )

# angular.module 'Scrumble.storage'
# .factory 'Sprint', (Parse, sprintUtils, $q) ->
#   class Sprint extends Parse.Model
#     @configure(
#       "Sprint",
#       "project",
#       "number",
#       "dates",
#       "resources",
#       "bdcData",
#       "isActive",
#       "doneColumn",
#       "sprintColumn",
#       "goal",
#       "indicators"
#     )
#
#     find = @find
#
#     handleDates = (sprint) ->
#       if sprint?.bdcData?
#         # the date is saved as a string so we've to convert it
#         for day in sprint.bdcData
#           day.date = moment(day.date).toDate()
#
#       # check start/end date consistency
#       if _.isArray(sprint?.dates?.days) and sprint?.dates?.days.length > 0
#         [first, ..., last] = sprint.dates.days
#         sprint.dates.start = moment(first.date).toDate()
#         sprint.dates.end = moment(last.date).toDate()
#       else
#         if sprint?
#           sprint.dates.start = null
#           sprint.dates.end = null
#       sprint
#
#     @find = (sprintId) ->
#       find.call @, sprintId
#       .then (sprint) ->
#         handleDates sprint
#
#     @getActiveSprint = (project) ->
#       @query(
#         where:
#           project:
#             __type: "Pointer"
#             className: "Project"
#             objectId: project.objectId
#           isActive: true
#       ).then (sprints) ->
#         console.warn 'Several sprints are active for this project' if sprints.length > 1
#         sprint = if sprints.length > 0 then sprints[0] else null
#         handleDates sprint
#
#     @setActiveSprint = (sprint) ->
#       sprint.isActive = true
#       sprint.save()
#
#     @deactivateSprint = (sprint) ->
#       sprint.isActive = false
#       sprint.save()
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
#     @closeActiveSprint = (project) ->
#       @getActiveSprint project
#       .then (sprint) ->
#         return unless sprint?
#         sprint.isActive = false
#         sprint.save()
#
#     @save = (sprint) ->
#       sprint.save()
#
#     @getLastSpeeds = (projectId) ->
#       @query(
#         where:
#           project:
#             __type: "Pointer"
#             className: "Project"
#             objectId: projectId
#       ).then (sprints) ->
#         _.sortByOrder sprints, 'number', false
#       .then (sprints) ->
#         result = []
#         for sprint in sprints[..2]
#           result.push
#             number: sprint.number
#             speed: sprintUtils.computeSpeed(sprint) or '?'
#         result
