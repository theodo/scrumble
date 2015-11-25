angular.module 'NotSoShitty.settings'
.directive 'selectColumns', ->
  restrict: 'E'
  templateUrl: 'settings/directives/select-columns/view.html'
  scope:
    boardColumns: '='
    columnIds: '='
  controller: 'SelectColumnsCtrl'
