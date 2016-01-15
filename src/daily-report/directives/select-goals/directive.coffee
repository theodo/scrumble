angular.module 'NotSoShitty.daily-report'
.directive 'selectGoals', ->
  restrict: 'E'
  templateUrl: 'daily-report/directives/select-goals/view.html'
  scope:
    goals: '='
    project: '='
    sprint: '='
  controller: 'SelectGoalsCtrl'
