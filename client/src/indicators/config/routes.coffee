angular.module 'Scrumble.indicators'
.config ['$stateProvider', ($stateProvider) ->
  $stateProvider
  .state 'tab.indicators',
    url: '/sprint/:sprintId/indicators'
    template: require('../states/base/view.html')
    controller: 'IndicatorsCtrl'
    resolve:
      currentSprint: (Sprint, $stateParams) ->
        Sprint.get
          sprintId: $stateParams.sprintId
          filter:
            include:
              project: 'organization'
  .state 'tab.labels',
    url: '/project/:projectId/labels'
    template: require('../states/labels/view.html')
    controller: 'LabelsCtrl'
]