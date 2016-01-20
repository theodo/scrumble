angular.module 'Scrumble.indicators'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.indicators',
    url: '/sprint/:sprintId/indicators'
    templateUrl: 'indicators/states/base/view.html'
    resolve:
      sprint: (Sprint, $stateParams) ->
        Sprint.find $stateParams.sprintId
  .state 'print-indicators',
    url: '/sprint/:sprintId/indicators/client-survey/print'
    templateUrl: 'indicators/states/print-client-survey/view.html'
    controller: 'PrintClientSurveyCtrl'
    resolve:
      sprint: (Sprint, $stateParams) ->
        Sprint.find $stateParams.sprintId
