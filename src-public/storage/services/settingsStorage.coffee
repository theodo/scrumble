angular.module 'NotSoShitty.storage'
.service 'SettingsStorage', (Settings, $q) ->
  get: (boardId) ->
    deferred = $q.defer()

    if boardId?
      Settings.query(
        where:
          boardId: boardId
      ).then (settingsArray) ->
        settings = if settingsArray.length > 0 then settingsArray[0] else null
        deferred.resolve settings
      .catch deferred.reject
    else
      deferred.reject 'No boardId'
    deferred.promise
