angular.module 'NotSoShitty.daily-report'
.directive 'previousGoals', ->
  restrict: 'E'
  templateUrl: 'daily-report/directives/previous-goals/view.html'
  scope:
    goals: '='
    sprint: '='
  controller: 'PreviousGoalsCtrl'
