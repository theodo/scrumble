angular.module 'NotSoShitty.storage'
.factory 'UserBoard', (Parse) ->
  class UserBoard extends Parse.Model
    @configure "UserBoard", "token", "boardId"
