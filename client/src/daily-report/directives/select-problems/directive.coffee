angular.module 'Scrumble.daily-report'
.directive 'selectProblems', ->
  restrict: 'E'
  templateUrl: 'daily-report/directives/select-problems/view.html'
  scope:
    markdown: '='
    project: '='
  controller: 'SelectProblemsCtrl'
