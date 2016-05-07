angular.module 'Scrumble.feedback'
.factory 'Feedback', (Parse) ->
  class Feedback extends Parse.Model
    @configure "Feedback", "reporter", "message"
