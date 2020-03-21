angular.module 'Scrumble.problems'
.directive 'problemsList2', ->
  restrict: 'E'
  templateUrl: 'problems/components/problems-list2/template.html'
  scope:
    problems: '='
