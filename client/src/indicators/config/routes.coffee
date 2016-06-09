angular.module 'Scrumble.indicators'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.indicators',
    url: '/sprint/:sprintId/indicators'
    templateUrl: 'indicators/states/base/view.html'
    controller: 'IndicatorsCtrl'
    resolve:
      currentSprint: (Sprint, $stateParams) ->
        Sprint.get
          sprintId: $stateParams.sprintId
          filter:
            include:
              project: 'organization'
