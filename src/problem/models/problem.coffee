angular.module 'NotSoShitty.problem'
.factory 'Problem', (Parse) ->
  class Problem extends Parse.Model
    @configure(
      "Problem",
      "project",
      "date",
      "description",
      "status",
      "resolution",
      "causeAssumption",
      "checks",
      "status"
    )
    @getByProjectId = (projectId) ->
      @query(
        where:
          project:
            __type: "Pointer"
            className: "Project"
            objectId: projectId
      ).then (problems) ->
        _.sortByOrder problems, 'date', false
