angular.module 'Scrumble.common'
.directive 'hcChart', ->
  restrict: 'E',
  template: '<div></div>',
  scope:
    options: '='
  link: (scope, element) ->
    Highcharts.chart(element[0], scope.options)
