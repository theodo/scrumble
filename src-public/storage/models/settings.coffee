angular.module 'NotSoShitty.storage'
.factory 'Settings', (Parse) ->
  class Settings extends Parse.Model
    @configure "Settings", "data", "boardId"
