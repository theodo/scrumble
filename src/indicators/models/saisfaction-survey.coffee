angular.module 'Scrumble.indicators'
.factory 'SatisfactionSurveyTemplate', (Parse) ->
  class SatisfactionSurveyTemplate extends Parse.Model
    @configure "SatisfactionSurveyTemplate", "questions", "company"
