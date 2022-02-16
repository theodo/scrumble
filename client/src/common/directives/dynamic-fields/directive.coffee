template = require './view.html'

angular.module 'Scrumble.common'
.directive 'dynamicFieldsList', ->
  restrict: 'E'
  template: template
  scope:
    availableFields: '='
