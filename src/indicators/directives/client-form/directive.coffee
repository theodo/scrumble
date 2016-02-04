angular.module 'Scrumble.indicators'
.directive 'clientForm', ->
  restrict: 'E'
  templateUrl: 'indicators/directives/client-form/view.html'
  scope:
    onSave: '&'
    template: '='
    indicators: '='
  controller: 'ClientFormCtrl'
