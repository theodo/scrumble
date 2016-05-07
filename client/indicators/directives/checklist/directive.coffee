angular.module 'Scrumble.indicators'
.directive 'checklist', ->
  restrict: 'E'
  templateUrl: 'indicators/directives/checklist/view.html'
  scope:
    sprint: '='
    template: '='
  controller: 'ChecklistCtrl'
