angular.module 'NotSoShitty.storage'
.service 'SettingsStorage', (Settings) ->
  get: (boardId) ->
    return null unless boardId?
    Settings.query(
      where:
        boardId: boardId
    ).then (settingsArray) ->
      if settingsArray.length > 0 then settingsArray[0] else null
