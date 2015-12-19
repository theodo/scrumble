angular.module 'NotSoShitty.common'
.directive 'dynamicFieldsList', ->
  restrict: 'E'
  templateUrl: 'common/directives/dynamic-fields/view.html'
  scope:
    availableFields: '='
