angular.module 'Scrumble.storage'
.factory 'Sprint', (Parse, sprintUtils) ->
  class Sprint extends Parse.Model
    @configure(
      "Sprint",
      "project",
      "number",
      "dates",
      "resources",
      "bdcData",
      "isActive",
      "doneColumn",
      "sprintColumn",
      "bdcBase64",
      "goal"
    )

    @getActiveSprint = (project) ->
      @query(
        where:
          project:
            __type: "Pointer"
            className: "Project"
            objectId: project.objectId
          isActive: true
      ).then (sprints) ->
        console.warn 'Several sprints are active for this project' if sprints.length > 1
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

    @closeActiveSprint = (project) ->
      @getActiveSprint project
      .then (sprint) ->
        sprint.isActive = false
        sprint.save()
