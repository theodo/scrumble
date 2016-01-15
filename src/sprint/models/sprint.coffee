angular.module 'NotSoShitty.storage'
.factory 'Sprint', (Parse, sprintUtils) ->
  class Sprint extends Parse.Model
    @configure "Sprint", "project", "number", "dates", "resources", "bdcData", "isActive", "doneColumn", "bdcBase64", "goal"

    @getActiveSprint = (project) ->
      @query(
        where:
          project:
            __type: "Pointer"
            className: "Project"
            objectId: project.objectId
          isActive: true
      ).then (sprints) ->
        sprint = if sprints.length > 0 then sprints[0] else null
        sprint
      .catch (err) ->
        console.warn err

    @getByProjectId = (projectId) ->
      @query(
        where:
          project:
            __type: "Pointer"
            className: "Project"
            objectId: projectId
      ).then (sprints) ->
        _.sortByOrder sprints, 'number', false
    @close = (sprint) ->
      sprint.isActive = false
      sprint.save()
    @getLastSpeeds = (projectId) ->
      console.log projectId
      @query(
        where:
          project:
            __type: "Pointer"
            className: "Project"
            objectId: projectId
      ).then (sprints) ->
        _.sortByOrder sprints, 'number', false
      .then (sprints) ->
        result = []
        for sprint in sprints[..2]
          result.push
            number: sprint.number
            speed: sprintUtils.computeSpeed(sprint) or '?'
        result
