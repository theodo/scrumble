angular.module 'Scrumble.daily-report'
.directive 'selectGoals', ->
  restrict: 'E'
  templateUrl: 'daily-report/directives/select-goals/view.html'
  scope:
    markdown: '='
    project: '='
    sprint: '='
  controller: 'SelectGoalsCtrl'
