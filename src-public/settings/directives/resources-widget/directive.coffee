angular.module 'NotSoShitty.settings'
.directive 'resourcesWidget', ->
  restrict: 'E'
  templateUrl: 'settings/directives/resources-widget/view.html'
  scope:
    boardMembers: '='
    team: '='
    dates: '='
    resources: '='
  controller: 'ResourcesWidgetCtrl'
