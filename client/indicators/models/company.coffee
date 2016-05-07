angular.module 'Scrumble.indicators'
.factory 'Company', (Parse) ->
  class Company extends Parse.Model
    @configure "Company", "company", "checklists", "satisfactionSurvey"
