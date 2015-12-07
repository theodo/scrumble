angular.module 'NotSoShitty.storage'
.factory 'DailyMail', (Parse) ->
  class DailyMail extends Parse.Model
    @configure "DailyMail", "boardId", "to", "cc", "subject", "body"
