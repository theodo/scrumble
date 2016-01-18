angular.module 'Scrumble.storage'
.factory 'Sprint', (Parse, sprintUtils, $q) ->
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

    activeSprint = null

    @getActiveSprint = (project) ->
      deferred = $q.defer()

      if activeSprint?
        deferred.resolve activeSprint
      else
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
          activeSprint = sprint
          deferred.resolve sprint
        .catch deferred.reject

      deferred.promise

    @setActiveSprint = (sprint) ->
      activeSprint = sprint
      sprint.isActive = true
      sprint.save()

    @deactivateSprint = (sprint) ->
      if activeSprint is sprint
        activeSprint = null
      sprint.isActive = false
      sprint.save()

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
        activeSprint = null
        sprint.isActive = false
        sprint.save()

    @save = (sprint) ->
      if sprint.isActive
        activeSprint = sprint
      sprint.save()
