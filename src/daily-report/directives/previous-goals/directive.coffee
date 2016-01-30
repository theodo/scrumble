angular.module 'Scrumble.daily-report'
.directive 'previousGoals', ->
  restrict: 'E'
  templateUrl: 'daily-report/directives/previous-goals/view.html'
  scope:
    markdown: '='
    sprint: '='
  controller: 'PreviousGoalsCtrl'
