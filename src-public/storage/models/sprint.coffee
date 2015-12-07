angular.module 'NotSoShitty.storage'
.factory 'Sprint', (Parse) ->
  class Sprint extends Parse.Model
    @configure "Sprint", "boardId", "number", "dates", "resources"
