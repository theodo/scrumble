angular.module 'NotSoShitty.storage'
.factory 'Project', (Parse, $q) ->
  class Project extends Parse.Model
    @configure "Project", "boardId", "name", "columnMapping", "team", "currentSprint"

    @get = (boardId) ->
      deferred = $q.defer()

      if boardId?
        @query(
          where:
            boardId: boardId
        ).then (settingsArray) ->
          settings = if settingsArray.length > 0 then settingsArray[0] else null
          deferred.resolve settings
        .catch deferred.reject
      else
        deferred.reject 'No boardId'
      deferred.promise
