angular.module 'NotSoShitty.storage'
.factory 'Sprint', (Parse) ->
  class Sprint extends Parse.Model
    @configure "Sprint", "project", "number", "dates", "resources", "bdcData", "isActive", "doneColumn"

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
