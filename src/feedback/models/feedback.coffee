angular.module 'NotSoShitty.feedback'
.factory 'Feedback', (Parse) ->
  class Feedback extends Parse.Model
    @configure "Feedback", "reporter", "message"
