angular.module 'Scrumble.common'
.directive 'dynamicFieldsList', ->
  restrict: 'E'
  templateUrl: 'common/directives/dynamic-fields/view.html'
  scope:
    availableFields: '='
